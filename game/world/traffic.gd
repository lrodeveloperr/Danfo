class_name Traffic
extends Node3D
## Work-mode traffic: kinematic cars, kekes and other danfos that drive on the
## right along the road graph, turn at junctions, take turns through each
## junction, and slow for anything ahead (including the player's bus).

const LANE_OFFSET := 1.7
const CAR_COLORS := [
	Color(0.85, 0.85, 0.85), Color(0.1, 0.1, 0.12), Color(0.55, 0.05, 0.05), Color(0.2, 0.3, 0.55),
	Color(0.6, 0.6, 0.62), Color(0.95, 0.95, 0.95), Color(0.3, 0.35, 0.3), Color(0.75, 0.6, 0.35),
]

var layout: DistrictLayout
var vehicles: Array[TrafficVehicle] = []
var reservations := {} # junction id -> vehicle
var rng := RandomNumberGenerator.new()


func populate(district: DistrictLayout, count: int, avoid: Vector3) -> void:
	layout = district
	rng.seed = 404
	var edges := layout.graph.edges.duplicate()
	var placed := 0
	var attempts := 0
	while placed < count and attempts < count * 10:
		attempts += 1
		var e: Vector2i = edges[rng.randi() % edges.size()]
		var forward := rng.randf() < 0.5
		var a := e.x if forward else e.y
		var b := e.y if forward else e.x
		var mid := (layout.graph.node_position(a) + layout.graph.node_position(b)) * 0.5
		if mid.distance_to(avoid) < 40.0:
			continue
		var kind := "car"
		var roll := rng.randf()
		if roll < 0.15:
			kind = "danfo"
		elif roll < 0.27:
			kind = "keke"
		var v := TrafficVehicle.create(kind, CAR_COLORS[rng.randi() % CAR_COLORS.size()])
		v.traffic = self
		add_child(v)
		v.start_on(a, b, rng.randf_range(0.2, 0.8), rng.randf_range(8.0, 12.5))
		vehicles.append(v)
		placed += 1


func lane_point(a: int, b: int, t: float) -> Vector3:
	var pa := layout.graph.node_position(a)
	var pb := layout.graph.node_position(b)
	var dir := (pb - pa).normalized()
	var hw := DistrictLayout.ROAD_WIDTH * 0.5
	var start := pa + dir * hw
	var end := pb - dir * hw
	return start.lerp(end, t) + RoadGraph.right_of(dir) * LANE_OFFSET


func next_node(prev: int, at: int) -> int:
	var options: Array[int] = []
	for n in layout.graph.neighbors(at):
		if n != prev:
			options.append(n)
	if options.is_empty():
		return prev
	return options[rng.randi() % options.size()]


func try_reserve(junction: int, v: TrafficVehicle) -> bool:
	var holder: TrafficVehicle = reservations.get(junction)
	if holder == null or holder == v or not is_instance_valid(holder):
		reservations[junction] = v
		return true
	return false


func release(junction: int, v: TrafficVehicle) -> void:
	if reservations.get(junction) == v:
		reservations.erase(junction)


class TrafficVehicle extends AnimatableBody3D:
	var traffic: Traffic
	var kind := "car"
	var a := 0
	var b := 1
	var t := 0.0
	var cruise := 10.0
	var speed := 0.0
	var turning := false
	var _turn_from := Vector3.ZERO
	var _turn_ctrl := Vector3.ZERO
	var _turn_to := Vector3.ZERO
	var _turn_t := 0.0
	var _turn_len := 1.0
	var _next := 0
	var _length := 4.2

	static func create(kind_: String, color: Color) -> TrafficVehicle:
		var v := TrafficVehicle.new()
		v.kind = kind_
		v.sync_to_physics = true
		v.collision_layer = Bus.LAYER_VEHICLES
		v.collision_mask = 0
		var size := Vector3(1.8, 1.4, 4.2)
		var st := MeshKit.begin()
		match kind_:
			"danfo":
				size = Vector3(1.84, 1.95, 4.57)
				var yellow := Color(0.95, 0.74, 0.05)
				MeshKit.box(st, Vector3(0, 0.5, 0), Vector3(1.84, 0.8, 4.57), yellow)
				MeshKit.box(st, Vector3(0, 1.2, 0), Vector3(1.8, 0.6, 4.5), BusVisual.GLASS)
				MeshKit.box(st, Vector3(0, 1.6, 0), Vector3(1.82, 0.22, 4.53), yellow)
				for y in [0.82, 0.52]:
					MeshKit.box(st, Vector3(0, y, 0), Vector3(1.854, 0.075, 4.584), Color(0.06, 0.06, 0.06))
			"keke":
				size = Vector3(1.3, 1.75, 2.7)
				MeshKit.box(st, Vector3(0, 0.55, 0.2), Vector3(1.3, 0.7, 2.2), Color(0.95, 0.75, 0.05))
				MeshKit.box(st, Vector3(0, 1.55, 0.25), Vector3(1.3, 0.1, 2.0), Color(0.1, 0.4, 0.2))
				for x in [-0.6, 0.6]:
					MeshKit.box(st, Vector3(x, 1.1, 0.25), Vector3(0.05, 0.9, 0.05), Color(0.2, 0.2, 0.2))
				MeshKit.box(st, Vector3(0, 0.75, -1.05), Vector3(0.5, 0.6, 0.5), Color(0.95, 0.75, 0.05))
			_:
				MeshKit.box(st, Vector3(0, 0.45, 0), Vector3(1.8, 0.6, 4.2), color)
				MeshKit.box(st, Vector3(0, 0.98, 0.2), Vector3(1.6, 0.5, 2.2), BusVisual.GLASS)
				MeshKit.box(st, Vector3(0, 1.25, 0.2), Vector3(1.55, 0.06, 2.0), color)
		for wx in [-size.x * 0.45, size.x * 0.45]:
			for wz in [-size.z * 0.32, size.z * 0.32]:
				MeshKit.box(st, Vector3(wx, 0.3, wz), Vector3(0.2, 0.6, 0.6), Color(0.06, 0.06, 0.06))
		var mi := MeshKit.mesh_instance(st, 0.5)
		mi.visibility_range_end = 220.0
		v.add_child(mi)
		var shadow := MeshKit.blob_shadow(size.x + 0.6, size.z + 0.8)
		shadow.position.y = 0.03
		v.add_child(shadow)
		var shape := CollisionShape3D.new()
		var box := BoxShape3D.new()
		box.size = size
		shape.shape = box
		shape.position = Vector3(0, size.y * 0.5, 0)
		v.add_child(shape)
		v._length = size.z
		return v

	func start_on(from: int, to: int, progress: float, cruise_speed: float) -> void:
		a = from
		b = to
		t = progress
		cruise = cruise_speed
		speed = cruise
		_place(traffic.lane_point(a, b, t), traffic.lane_point(a, b, minf(t + 0.05, 1.0)))

	func _place(pos: Vector3, look: Vector3) -> void:
		var xf := Transform3D(Basis.IDENTITY, pos)
		if look.distance_to(pos) > 0.01:
			xf = xf.looking_at(look, Vector3.UP)
		global_transform = xf

	func _physics_process(delta: float) -> void:
		var target_speed := cruise
		var gap := _clear_distance()
		if gap < 14.0:
			target_speed = minf(target_speed, maxf(gap - 4.0, 0.0) * 0.9)
		speed = move_toward(speed, target_speed, (6.0 if target_speed < speed else 2.5) * delta)
		if turning:
			_turn_t += speed * delta / _turn_len
			if _turn_t >= 1.0:
				turning = false
				traffic.release(b, self)
				a = b
				b = _next
				t = 0.0
			else:
				_place(_bezier(_turn_t), _bezier(minf(_turn_t + 0.05, 1.0)))
			return
		var seg := traffic.layout.graph.node_position(a).distance_to(traffic.layout.graph.node_position(b)) - DistrictLayout.ROAD_WIDTH
		var nt := t + speed * delta / maxf(seg, 1.0)
		if nt >= 1.0:
			# Wait at the stop line until the junction is free.
			if not traffic.try_reserve(b, self):
				speed = 0.0
				return
			_next = traffic.next_node(a, b)
			_begin_turn()
			return
		t = nt
		_place(traffic.lane_point(a, b, t), traffic.lane_point(a, b, minf(t + 0.05, 1.0)))

	func _begin_turn() -> void:
		turning = true
		_turn_t = 0.0
		_turn_from = traffic.lane_point(a, b, 1.0)
		_turn_to = traffic.lane_point(b, _next, 0.0)
		_turn_ctrl = traffic.layout.graph.node_position(b)
		var in_dir := (traffic.layout.graph.node_position(b) - traffic.layout.graph.node_position(a)).normalized()
		var out_dir := (traffic.layout.graph.node_position(_next) - traffic.layout.graph.node_position(b)).normalized()
		if in_dir.dot(out_dir) > 0.9:
			_turn_ctrl = (_turn_from + _turn_to) * 0.5
		else:
			# Corner control point where the two lanes would meet.
			_turn_ctrl = _turn_from + in_dir * absf((_turn_to - _turn_from).dot(in_dir))
		_turn_len = _turn_from.distance_to(_turn_ctrl) + _turn_ctrl.distance_to(_turn_to)

	func _bezier(u: float) -> Vector3:
		var q0 := _turn_from.lerp(_turn_ctrl, u)
		var q1 := _turn_ctrl.lerp(_turn_to, u)
		return q0.lerp(q1, u)

	func _clear_distance() -> float:
		var fwd := -global_transform.basis.z
		var from := global_position + Vector3.UP * 0.8 + fwd * (_length * 0.5 + 0.2)
		var query := PhysicsRayQueryParameters3D.create(from, from + fwd * 16.0, Bus.LAYER_VEHICLES, [get_rid()])
		var hit := get_world_3d().direct_space_state.intersect_ray(query)
		if hit.is_empty():
			return INF
		return from.distance_to(hit["position"])
