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
## Traffic is kept dense around this node (the player's bus): vehicles that
## drift far away are recycled onto roads nearby, out of the way.
var focus: Node3D
const BUBBLE_NEAR := 60.0
const BUBBLE_FAR := 210.0
const RECYCLE_AT := 250.0
var _recycle_timer := 0.0
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
		if mid.distance_to(avoid) < 25.0 or mid.distance_to(avoid) > BUBBLE_FAR + 40.0:
			continue
		# Lagos mix: danfos everywhere, then cars, okadas, kekes, the odd truck.
		var kind := "car"
		var roll := rng.randf()
		if roll < 0.34:
			kind = "danfo"
		elif roll < 0.52:
			kind = "okada"
		elif roll < 0.64:
			kind = "keke"
		elif roll < 0.7:
			kind = "truck"
		var v := TrafficVehicle.create(kind, CAR_COLORS[rng.randi() % CAR_COLORS.size()], rng)
		v.traffic = self
		add_child(v)
		v.start_on(a, b, rng.randf_range(0.2, 0.8), rng.randf_range(8.0, 12.5))
		vehicles.append(v)
		placed += 1


## Cars, danfos and kekes parked half up on the kerb along the roads, kept
## clear of stops and junctions. One merged mesh and one static body.
func park_vehicles(district: DistrictLayout, count: int) -> void:
	layout = district
	var r := RandomNumberGenerator.new()
	r.seed = 77
	var st := MeshKit.begin()
	var body := StaticBody3D.new()
	body.collision_layer = Bus.LAYER_VEHICLES
	body.collision_mask = 0
	add_child(body)
	var stop_points: Array[Vector3] = []
	for stop in layout.stops:
		for side in stop["sides"]:
			stop_points.append(side["stop_point"])
	var placed := 0
	var tries := 0
	while placed < count and tries < count * 20:
		tries += 1
		var e: Vector2i = layout.graph.edges[r.randi() % layout.graph.edges.size()]
		var a := layout.graph.node_position(e.x)
		var b := layout.graph.node_position(e.y)
		var dir := (b - a).normalized()
		var side := 1.0 if r.randf() < 0.5 else -1.0
		var t := r.randf_range(0.18, 0.82)
		var pos := a.lerp(b, t) + RoadGraph.right_of(dir) * side * 5.5
		var clear := true
		for sp in stop_points:
			if sp.distance_to(pos) < 20.0:
				clear = false
		for v in vehicles:
			if v.global_position.distance_to(pos) < 9.0:
				clear = false
		if not clear:
			continue
		var kinds := ["car", "car", "danfo", "keke", "car"]
		var kind: String = kinds[r.randi() % kinds.size()]
		var vst := MeshKit.begin()
		var size := vehicle_mesh(vst, kind, CAR_COLORS[r.randi() % CAR_COLORS.size()], r)
		var facing := dir if side > 0.0 else -dir
		var xf := Transform3D(Basis.looking_at(facing, Vector3.UP).rotated(facing, side * 0.06), pos + Vector3(0, 0.08, 0))
		st.append_from(vst.commit(), 0, xf)
		CityBuilder.add_box_collider(body, xf.origin + Vector3(0, size.y * 0.5, 0), size, xf.basis)
		placed += 1
	if placed > 0:
		st.index()
		var mi := MeshInstance3D.new()
		mi.mesh = st.commit()
		mi.material_override = MeshKit.weathered(0.6, 0.3, 0.45)
		add_child(mi)


func _physics_process(delta: float) -> void:
	if focus == null or not is_instance_valid(focus):
		return
	_recycle_timer -= delta
	if _recycle_timer > 0.0:
		return
	_recycle_timer = 0.8
	var p := focus.global_position
	for v in vehicles:
		if not v.turning and v.global_position.distance_to(p) > RECYCLE_AT:
			_respawn_near(v, p)


func _respawn_near(v: TrafficVehicle, p: Vector3) -> void:
	for attempt in 16:
		var e: Vector2i = layout.graph.edges[rng.randi() % layout.graph.edges.size()]
		var forward := rng.randf() < 0.5
		var a := e.x if forward else e.y
		var b := e.y if forward else e.x
		var t := rng.randf_range(0.1, 0.9)
		var pos := lane_point(a, b, t)
		var d := pos.distance_to(p)
		if d < BUBBLE_NEAR or d > BUBBLE_FAR:
			continue
		var clear := true
		for other in vehicles:
			if other != v and other.global_position.distance_to(pos) < 12.0:
				clear = false
				break
		if clear:
			v.start_on(a, b, t, rng.randf_range(7.0, 12.0))
			return


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


## Builds a traffic or parked vehicle into `st` (origin on the ground) and
## returns its collision size. Everything is battered to some degree.
static func vehicle_mesh(st: SurfaceTool, kind: String, color: Color, r: RandomNumberGenerator) -> Vector3:
	var size := Vector3(1.8, 1.4, 4.3)
	var dark := Color(0.06, 0.06, 0.06)
	match kind:
		"danfo":
			size = Vector3(1.84, 1.95, 4.57)
			var yellow := Color(0.95, 0.74, 0.05).lerp(Color(0.9, 0.82, 0.45), r.randf() * 0.4)
			MeshKit.box(st, Vector3(0, 0.62, 0), Vector3(1.84, 0.8, 4.57), yellow)
			MeshKit.box(st, Vector3(0, 1.32, 0), Vector3(1.8, 0.6, 4.5), BusVisual.GLASS)
			MeshKit.box(st, Vector3(0, 1.73, 0), Vector3(1.82, 0.22, 4.53), yellow)
			for y: float in [0.94, 0.64]:
				MeshKit.box(st, Vector3(0, y, 0), Vector3(1.854, 0.075, 4.584), dark)
			for p in r.randi_range(1, 5):
				var tone: Color = [Color(0.45, 0.24, 0.13), Color(0.55, 0.56, 0.53)][r.randi() % 2]
				MeshKit.box(st, Vector3(0.925 * (1 if r.randf() < 0.5 else -1), r.randf_range(0.35, 0.95), r.randf_range(-2.0, 2.0)), Vector3(0.012, 0.2, r.randf_range(0.2, 0.7)), tone)
			for x: float in [-1.0, 1.0]:
				for z: float in [-1.23, 1.23]:
					MeshKit.box(st, Vector3(x * 0.8, 0.34, z), Vector3(0.24, 0.68, 0.68), dark)
		"keke":
			size = Vector3(1.35, 1.8, 2.8)
			var yellow := Color(0.96, 0.78, 0.08)
			MeshKit.box(st, Vector3(0, 0.6, 0.3), Vector3(1.3, 0.6, 1.9), yellow)
			MeshKit.box(st, Vector3(0, 0.9, -1.0), Vector3(0.7, 0.9, 0.6), yellow)
			MeshKit.box(st, Vector3(0, 1.75, 0.0), Vector3(1.35, 0.08, 2.6), dark.lightened(0.1))
			for x: float in [-0.62, 0.62]:
				MeshKit.box(st, Vector3(x, 1.25, 0.9), Vector3(0.05, 1.0, 0.05), dark)
			MeshKit.box(st, Vector3(0, 1.3, -1.25), Vector3(1.1, 0.7, 0.03), BusVisual.GLASS)
			MeshKit.box(st, Vector3(0, 0.95, 0.3), Vector3(1.2, 0.35, 1.0), Color(0.15, 0.15, 0.15))
			for wheel: Vector3 in [Vector3(0, 0.25, -1.1), Vector3(-0.6, 0.25, 0.7), Vector3(0.6, 0.25, 0.7)]:
				MeshKit.box(st, wheel, Vector3(0.14, 0.5, 0.5), dark)
		"okada":
			size = Vector3(0.7, 1.7, 1.9)
			StreetDressing.okada_mesh(st, Vector3.ZERO, Vector3.FORWARD, r)
			# Rider (and often a passenger) in place.
			var shirt: Color = StreetDressing.CLOTHES[r.randi() % StreetDressing.CLOTHES.size()]
			MeshKit.box(st, Vector3(0, 1.2, 0.05), Vector3(0.42, 0.6, 0.28), shirt)
			MeshKit.box(st, Vector3(0, 1.62, 0.0), Vector3(0.24, 0.26, 0.26), Color(0.28, 0.17, 0.1))
			if r.randf() < 0.6:
				var shirt2: Color = StreetDressing.CLOTHES[r.randi() % StreetDressing.CLOTHES.size()]
				MeshKit.box(st, Vector3(0, 1.22, 0.55), Vector3(0.42, 0.6, 0.28), shirt2)
				MeshKit.box(st, Vector3(0, 1.64, 0.55), Vector3(0.24, 0.26, 0.26), Color(0.33, 0.2, 0.12))
		"truck":
			size = Vector3(2.4, 3.2, 8.5)
			var cab: Color = [Color(0.85, 0.85, 0.82), Color(0.2, 0.35, 0.6), Color(0.65, 0.12, 0.1)][r.randi() % 3]
			MeshKit.box(st, Vector3(0, 1.4, -3.3), Vector3(2.4, 2.2, 1.9), cab)
			MeshKit.box(st, Vector3(0, 1.9, -4.26), Vector3(2.1, 0.8, 0.04), BusVisual.GLASS)
			if r.randf() < 0.5:
				MeshKit.prism(st, Vector3(0, 0.9, 1.0), 1.1, 2.0, Color(0.7, 0.7, 0.72), 10)
			else:
				MeshKit.box(st, Vector3(0, 1.8, 1.0), Vector3(2.4, 2.6, 6.2), Color(0.45, 0.32, 0.2))
			MeshKit.box(st, Vector3(0, 0.55, 0.5), Vector3(1.0, 0.3, 8.0), dark)
			for z: float in [-3.3, 0.5, 2.6]:
				for x: float in [-1.05, 1.05]:
					MeshKit.box(st, Vector3(x, 0.5, z), Vector3(0.3, 1.0, 1.0), dark)
		_:
			var body := color.lerp(Color(0.6, 0.58, 0.55), r.randf() * 0.3)
			MeshKit.box(st, Vector3(0, 0.62, 0), Vector3(1.8, 0.62, 4.3), body)
			MeshKit.box(st, Vector3(0, 1.15, 0.15), Vector3(1.62, 0.5, 2.2), BusVisual.GLASS)
			MeshKit.box(st, Vector3(0, 1.42, 0.15), Vector3(1.56, 0.06, 2.0), body)
			if r.randf() < 0.4:
				# Mismatched door from a different car.
				MeshKit.box(st, Vector3(0.905, 0.62, -0.2), Vector3(0.012, 0.55, 1.0), CAR_COLORS[r.randi() % CAR_COLORS.size()])
			MeshKit.box(st, Vector3(0, 0.4, -2.18), Vector3(1.7, 0.18, 0.08), dark)
			for x: float in [-0.82, 0.82]:
				for z: float in [-1.35, 1.35]:
					MeshKit.box(st, Vector3(x, 0.32, z), Vector3(0.2, 0.64, 0.64), dark)
	# Shadow pool on the road.
	MeshKit.box(st, Vector3(0, 0.035, 0), Vector3(size.x + 0.3, 0.005, size.z + 0.3), Color(0.08, 0.08, 0.08))
	return size


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

	static func create(kind_: String, color: Color, r: RandomNumberGenerator) -> TrafficVehicle:
		var v := TrafficVehicle.new()
		v.kind = kind_
		v.sync_to_physics = true
		v.collision_layer = Bus.LAYER_VEHICLES
		v.collision_mask = 0
		var st := MeshKit.begin()
		var size := Traffic.vehicle_mesh(st, kind_, color, r)
		st.index()
		var mi := MeshInstance3D.new()
		mi.mesh = st.commit()
		mi.material_override = MeshKit.weathered(0.6, 0.3, 0.45, true)
		mi.visibility_range_end = 220.0
		v.add_child(mi)
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
