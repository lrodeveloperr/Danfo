class_name BusAI
extends RefCounted
## Path-following danfo driver for rivals (and test autopilot). Uses the same
## Bus physics and inputs as the player: no teleporting ahead, no hidden power.
## Tactics change visible behaviour: late braking, lane choice, gap defence.

var points := PackedVector3Array()
var loop := true
var lane_offset := 0.0 # metres right of the path centre
var speed_factor := 1.0
var corner_factor := 1.0
var brake_late := 0.0 # 0..1, how deep into corners it brakes
var defend := 0.0 # 0..1, tendency to drift into the line of a bus behind
var max_speed := 24.0
## Optional stop point: the AI slows to a halt here (used by Work autopilot).
var stop_point: Variant = null
## When true the AI releases the controls and lets the bus hold still.
var hold := false

var _index := 0
var _stuck_time := 0.0
var _reverse_time := 0.0
var _best_index := 0
var _no_progress := 0.0
var _avoid := 0.0
var _space: PhysicsDirectSpaceState3D


static func densify(corners: PackedVector3Array, closed: bool, step := 4.0) -> PackedVector3Array:
	var out := PackedVector3Array()
	var count := corners.size() if closed else corners.size() - 1
	for i in count:
		var a := corners[i]
		var b := corners[(i + 1) % corners.size()]
		var n := maxi(1, int(a.distance_to(b) / step))
		for k in n:
			out.append(a.lerp(b, float(k) / n))
	if not closed:
		out.append(corners[corners.size() - 1])
	return out


func set_path(path: PackedVector3Array, closed: bool, start_near := Vector3.INF) -> void:
	points = path
	loop = closed
	_index = 0
	if start_near != Vector3.INF:
		_index = _closest_index(start_near, 0, points.size())
	_best_index = _index
	_no_progress = 0.0


func at_end() -> bool:
	return not loop and _index >= points.size() - 2


func drive_input(bus: Bus) -> Dictionary:
	if hold or points.size() < 2:
		return {"throttle": 0.0, "brake": 0.0, "steer": 0.0}
	_space = bus.get_world_3d().direct_space_state
	var pos := bus.global_position
	_index = _closest_index(pos, _index, 24)
	var look := 5.0 + absf(bus.speed) * 0.5
	var target := _point_ahead(look)
	_update_avoidance(bus)
	var dir := _direction_at(_index)
	target += RoadGraph.right_of(dir) * (lane_offset + _avoid)
	# Final approach: steer straight onto the kerbside stop point.
	if stop_point != null and pos.distance_to(stop_point) < 22.0:
		target = stop_point
	var to := target - pos
	to.y = 0.0
	var fwd := bus.forward_vector()
	fwd.y = 0.0
	var angle := fwd.signed_angle_to(to, Vector3.DOWN)
	var steer := clampf(angle / 0.55, -1.0, 1.0)

	var horizon := 12.0 + absf(bus.speed) * lerpf(1.7, 1.0, brake_late)
	var turn := _upcoming_turn(horizon)
	var corner_speed := lerpf(max_speed, 6.0, clampf(turn / (PI * 0.5), 0.0, 1.0)) * corner_factor
	var target_speed := minf(max_speed * speed_factor, corner_speed)
	if stop_point != null:
		var d := pos.distance_to(stop_point)
		target_speed = minf(target_speed, sqrt(maxf(d - 1.5, 0.0) * 4.0))
		if d < 2.5:
			target_speed = 0.0
	if not loop and _index >= points.size() - 3 and stop_point == null:
		target_speed = 0.0

	var err := target_speed - bus.speed
	var throttle := clampf(err * 0.45, 0.0, 1.0)
	var brake := clampf(-err * 0.4, 0.0, 1.0)
	if target_speed < 0.3 and absf(bus.speed) < 0.6:
		throttle = 0.0
		brake = 0.0 # hold still without reversing

	var dt := bus.get_physics_process_delta_time()
	# Overshot a turn: back up with opposite lock (a three-point turn).
	if absf(angle) > 1.9 and absf(bus.speed) < 3.0 and target_speed > 0.5:
		return {"throttle": 0.0, "brake": 1.0, "steer": -signf(angle)}
	# Unstick: back up briefly when pushing against something.
	if _reverse_time > 0.0:
		_reverse_time -= dt
		return {"throttle": 0.0, "brake": 1.0, "steer": -steer}
	if throttle > 0.3 and absf(bus.speed) < 0.7:
		_stuck_time += dt
		if _stuck_time > 1.6:
			_stuck_time = 0.0
			_reverse_time = 1.2
	else:
		_stuck_time = maxf(_stuck_time - dt, 0.0)
	# Last resort: no progress along the path for a while, so recover onto it.
	var progressed := _index > _best_index or (loop and _index < _best_index - points.size() / 2)
	if progressed:
		_best_index = _index
		_no_progress = 0.0
	elif target_speed > 0.5:
		_no_progress += dt
		if _no_progress > 8.0:
			_no_progress = 0.0
			bus.place_at(points[_index], Basis.looking_at(dir, Vector3.UP))
	return {"throttle": throttle, "brake": brake, "steer": steer}


func _update_avoidance(bus: Bus) -> void:
	var fwd := bus.forward_vector()
	var origin := bus.global_position + Vector3.UP * 0.6
	var ahead := PhysicsRayQueryParameters3D.create(origin + fwd * 2.6, origin + fwd * (8.0 + absf(bus.speed) * 0.6), Bus.LAYER_VEHICLES, [bus.get_rid()])
	var hit := _space.intersect_ray(ahead)
	var goal := 0.0
	if not hit.is_empty():
		# Pass on whichever side the obstacle leaves more room.
		var rel: Vector3 = hit["position"] - bus.global_position
		var side := signf(rel.dot(bus.global_transform.basis.x))
		goal = -side * 2.6 if side != 0.0 else 2.6
	elif defend > 0.0:
		var back := PhysicsRayQueryParameters3D.create(origin - fwd * 2.6, origin - fwd * 12.0, Bus.LAYER_VEHICLES, [bus.get_rid()])
		var behind := _space.intersect_ray(back)
		if not behind.is_empty():
			var rel_b: Vector3 = behind["position"] - bus.global_position
			goal = clampf(rel_b.dot(bus.global_transform.basis.x), -2.0, 2.0) * defend
	_avoid = move_toward(_avoid, goal, 0.06)


func _closest_index(pos: Vector3, from: int, window: int) -> int:
	var best := from
	var best_d := INF
	for k in range(-2, window):
		var i := from + k
		if loop:
			i = posmod(i, points.size())
		elif i < 0 or i >= points.size():
			continue
		var d := pos.distance_squared_to(points[i])
		if d < best_d:
			best_d = d
			best = i
	return best


func _point_ahead(distance: float) -> Vector3:
	var i := _index
	var travelled := 0.0
	while travelled < distance:
		var j := i + 1
		if loop:
			j = posmod(j, points.size())
		elif j >= points.size():
			return points[points.size() - 1]
		travelled += points[i].distance_to(points[j])
		i = j
	return points[i]


func _direction_at(i: int) -> Vector3:
	var j := i + 1
	if loop:
		j = posmod(j, points.size())
	elif j >= points.size():
		j = points.size() - 1
		i = maxi(j - 1, 0)
	var d := points[j] - points[i]
	return d.normalized() if d.length() > 0.01 else Vector3.FORWARD


func _upcoming_turn(distance: float) -> float:
	var base := _direction_at(_index)
	var steps := int(distance / 4.0)
	var worst := 0.0
	for k in range(1, steps + 1):
		var i := _index + k
		if loop:
			i = posmod(i, points.size())
		elif i >= points.size() - 1:
			break
		worst = maxf(worst, base.angle_to(_direction_at(i)))
	return worst
