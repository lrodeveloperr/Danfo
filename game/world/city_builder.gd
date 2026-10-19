class_name CityBuilder
extends Node3D
## Builds the visible and collidable test district from a DistrictLayout.
## Each city block is one merged, vertex-coloured mesh (one draw call) with a
## static body of box colliders. Business names are invented.

const ASPHALT := Color(0.24, 0.24, 0.25)
const MARKING := Color(0.8, 0.78, 0.7)
const PAVEMENT := Color(0.56, 0.53, 0.48)
const LATERITE := Color(0.6, 0.38, 0.24)
const WALLS := [
	Color(0.93, 0.89, 0.8), Color(0.86, 0.78, 0.6), Color(0.72, 0.82, 0.86), Color(0.8, 0.86, 0.74),
	Color(0.95, 0.95, 0.93), Color(0.74, 0.71, 0.67), Color(0.88, 0.7, 0.62), Color(0.68, 0.75, 0.62),
]
const ROOFS := [Color(0.47, 0.29, 0.18), Color(0.56, 0.36, 0.21), Color(0.42, 0.42, 0.44), Color(0.52, 0.49, 0.45)]
const AWNINGS := [Color(0.1, 0.35, 0.7), Color(0.75, 0.12, 0.1), Color(0.1, 0.5, 0.25), Color(0.95, 0.75, 0.1), Color(0.9, 0.45, 0.1)]
const SHUTTERS := [Color(0.12, 0.15, 0.18), Color(0.3, 0.2, 0.12), Color(0.15, 0.35, 0.25)]
const SHOP_NAMES := [
	"GOD'S GRACE PROVISIONS", "ADE & SONS AUTO PARTS", "BLESSED CHEMIST", "MAMA T BUKA",
	"NEW ERA TAILORING", "FAVOUR PHONE REPAIRS", "SEUN ELECTRICALS", "PEACE BARBING SALON",
	"EVERGREEN MINI MART", "TRUST GOD WELDING", "SWEET TASTE BAKERY", "UNITY VULCANISER",
	"MERCY FASHION HOME", "BOLA & CO PHOTOCOPY", "HOPE PAINTS & CHEMICALS", "DIVINE TOUCH SALON",
]

var layout: DistrictLayout
var rng := RandomNumberGenerator.new()
var _sign_index := 0


func build(district: DistrictLayout) -> void:
	layout = district
	rng.seed = 2026
	_build_ground()
	_build_roads()
	for block in layout.blocks:
		_build_block(block)
	_build_outer_belt()
	_build_stops()


func _static_body(name_: String) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = name_
	body.collision_layer = Bus.LAYER_WORLD
	body.collision_mask = 0
	add_child(body)
	return body


func _add_box_collider(body: StaticBody3D, center: Vector3, size: Vector3) -> void:
	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = size
	shape.shape = box
	shape.position = center
	body.add_child(shape)


func _build_ground() -> void:
	var extent := layout.half_extent() + 260.0
	var body := _static_body("Ground")
	_add_box_collider(body, Vector3(0, -0.5, 0), Vector3(extent * 2.0, 1.0, extent * 2.0))
	var st := MeshKit.begin()
	MeshKit.ground_quad(st, Vector3(-extent, 0, -extent), Vector3(extent, 0, -extent),
		Vector3(extent, 0, extent), Vector3(-extent, 0, extent), LATERITE.darkened(0.08))
	add_child(MeshKit.mesh_instance(st, 1.0))


func _build_roads() -> void:
	var st := MeshKit.begin()
	var hw := DistrictLayout.ROAD_WIDTH * 0.5
	for e in layout.graph.edges:
		var a := layout.graph.node_position(e.x)
		var b := layout.graph.node_position(e.y)
		var dir := (b - a).normalized()
		var right := RoadGraph.right_of(dir)
		var y := Vector3(0, 0.02, 0)
		MeshKit.ground_quad(st, a - right * hw + y, b - right * hw + y, b + right * hw + y, a + right * hw + y, ASPHALT)
		# Faded centre dashes, kept clear of junctions.
		var length := a.distance_to(b)
		var d := hw + 6.0
		while d < length - hw - 6.0:
			var p := a + dir * (d + 1.5)
			var size := Vector3(0.14, 0.01, 3.0) if absf(dir.z) > 0.5 else Vector3(3.0, 0.01, 0.14)
			MeshKit.box(st, p + Vector3(0, 0.025, 0), size, MARKING)
			d += 7.0
		# A few patched sections.
		for i in 2:
			var t := rng.randf_range(0.2, 0.8)
			var lateral := rng.randf_range(-hw + 2.0, hw - 2.0)
			var patch := a.lerp(b, t) + right * lateral + Vector3(0, 0.022, 0)
			var psize := Vector3(rng.randf_range(1.5, 3.5), 0.004, rng.randf_range(1.5, 4.0))
			MeshKit.box(st, patch, psize, ASPHALT.darkened(0.25) if i == 0 else ASPHALT.lightened(0.12))
	for id in layout.graph.positions:
		var p: Vector3 = layout.graph.node_position(id) + Vector3(0, 0.021, 0)
		MeshKit.ground_quad(st, p + Vector3(-hw, 0, -hw), p + Vector3(hw, 0, -hw), p + Vector3(hw, 0, hw), p + Vector3(-hw, 0, hw), ASPHALT)
	var mi := MeshKit.mesh_instance(st, 0.95)
	mi.name = "Roads"
	add_child(mi)


func _build_block(block: Dictionary) -> void:
	rng.seed = int(block["seed"])
	var c: Vector3 = block["center"]
	var s: float = block["size"]
	var kind: String = block["kind"]
	var st := MeshKit.begin()
	var body := _static_body("Block")
	# Raised pavement platform with a laterite interior.
	MeshKit.box(st, c + Vector3(0, 0.075, 0), Vector3(s, 0.15, s), PAVEMENT)
	_add_box_collider(body, c + Vector3(0, 0.075, 0), Vector3(s, 0.15, s))
	var inner := s - DistrictLayout.SIDEWALK * 2.0
	MeshKit.box(st, c + Vector3(0, 0.152, 0), Vector3(inner, 0.004, inner), LATERITE)
	match kind:
		"garage":
			_build_garage(st, body, c, inner)
		"market":
			_build_market(st, body, c, inner)
		_:
			for n: Vector3 in [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]:
				var shorten := 0.0 if absf(n.z) > 0.5 else 26.0
				_build_frontage(st, body, c, n, inner * 0.5, inner - shorten * 2.0)
	_build_trees(st, c, s)
	var mi := MeshKit.mesh_instance(st, 0.9)
	mi.name = "BlockMesh"
	add_child(mi)


## A row of buildings whose fronts face along `n`, at `front` from `origin`.
func _build_frontage(st: SurfaceTool, body: StaticBody3D, origin: Vector3, n: Vector3, front: float, span: float) -> void:
	var along := n.cross(Vector3.UP)
	var cursor := -span * 0.5
	while cursor < span * 0.5 - 6.0:
		var w := minf(rng.randf_range(7.0, 15.0), span * 0.5 - cursor)
		var depth := rng.randf_range(9.0, 13.0)
		var roll := rng.randf()
		var floors := 1 if roll < 0.3 else (2 if roll < 0.65 else (3 if roll < 0.9 else 4))
		var h := floors * 3.1 + 0.3
		var front_center := origin + n * (front - 0.4) + along * (cursor + w * 0.5)
		var center := front_center - n * depth * 0.5 + Vector3(0, 0.15 + h * 0.5, 0)
		var size := Vector3(w, h, depth) if absf(n.z) > 0.5 else Vector3(depth, h, w)
		var wall: Color = WALLS[rng.randi() % WALLS.size()]
		MeshKit.box(st, center, size, wall)
		_add_box_collider(body, center, size)
		var roof_size := size + Vector3(0.3, 0.0, 0.3)
		roof_size.y = 0.25
		MeshKit.box(st, center + Vector3(0, h * 0.5 + 0.12, 0), roof_size, ROOFS[rng.randi() % ROOFS.size()])
		_decorate_facade(st, front_center, n, along, w, floors)
		if rng.randf() < 0.45:
			var tank_pos := center + Vector3(0, h * 0.5 + 0.9, 0) - n * depth * 0.2 + along * rng.randf_range(-w * 0.3, w * 0.3)
			MeshKit.box(st, tank_pos, Vector3(1.2, 1.5, 1.2), Color(0.08, 0.08, 0.09) if rng.randf() < 0.7 else Color(0.15, 0.3, 0.6))
		cursor += w + (rng.randf_range(1.0, 3.0) if rng.randf() < 0.35 else 0.0)


func _decorate_facade(st: SurfaceTool, front_center: Vector3, n: Vector3, along: Vector3, w: float, floors: int) -> void:
	var base_y := 0.15
	var face := front_center + n * 0.03
	var shop := rng.randf() < 0.75
	if shop:
		# Shop opening, awning and a hand-painted style sign board.
		MeshKit.box(st, face + Vector3(0, base_y + 1.25, 0), _oriented(n, w * 0.7, 2.5, 0.05), Color(0.1, 0.1, 0.1))
		var awning: Color = AWNINGS[rng.randi() % AWNINGS.size()]
		MeshKit.box(st, face + n * 0.65 + Vector3(0, base_y + 2.75, 0), _oriented(n, w * 0.85, 0.12, 1.3), awning)
		var board := face + Vector3(0, base_y + 3.15 if floors == 1 else base_y + 3.2, 0)
		MeshKit.box(st, board, _oriented(n, w * 0.8, 0.55, 0.06), Color(0.96, 0.95, 0.9))
		if rng.randf() < 0.35:
			_add_sign(board + n * 0.05, n, SHOP_NAMES[_sign_index % SHOP_NAMES.size()], w * 0.75)
			_sign_index += 1
	else:
		MeshKit.box(st, face + Vector3(0, base_y + 1.1, 0), _oriented(n, 1.1, 2.1, 0.05), Color(0.35, 0.22, 0.12))
	for f in range(1, floors):
		var y := base_y + f * 3.1 + 1.5
		var count := maxi(1, int(w / 3.2))
		for k in count:
			var offset := (k - (count - 1) * 0.5) * (w / count)
			var shutter: Color = SHUTTERS[rng.randi() % SHUTTERS.size()]
			MeshKit.box(st, face + along * offset + Vector3(0, y, 0), _oriented(n, 1.1, 1.2, 0.05), shutter)


static func _oriented(n: Vector3, w: float, h: float, d: float) -> Vector3:
	return Vector3(w, h, d) if absf(n.z) > 0.5 else Vector3(d, h, w)


func _add_sign(pos: Vector3, n: Vector3, text: String, width: float) -> void:
	var label := Label3D.new()
	label.text = text
	label.font_size = 64
	label.pixel_size = clampf(width / (text.length() * 40.0), 0.004, 0.012)
	label.modulate = AWNINGS[rng.randi() % AWNINGS.size()].darkened(0.3)
	label.outline_size = 0
	# Label3D text faces +Z, so point +Z out towards the road.
	label.transform = Transform3D(Basis.looking_at(-n, Vector3.UP), pos)
	label.double_sided = false
	label.visibility_range_end = 140.0
	add_child(label)


func _build_trees(st: SurfaceTool, c: Vector3, s: float) -> void:
	for i in 3:
		if rng.randf() < 0.5:
			continue
		var edge := s * 0.5 - 1.3
		var side := rng.randi() % 4
		var t := rng.randf_range(-edge * 0.8, edge * 0.8)
		var p := c + Vector3([edge, -edge, t, t][side], 0.15, [t, t, edge, -edge][side])
		MeshKit.box(st, p + Vector3(0, 1.5, 0), Vector3(0.35, 3.0, 0.35), Color(0.35, 0.25, 0.16))
		var leaf := Color(0.2, 0.42, 0.16).lerp(Color(0.32, 0.5, 0.2), rng.randf())
		MeshKit.box(st, p + Vector3(0, 3.6, 0), Vector3(3.2, 1.6, 3.2), leaf)
		MeshKit.box(st, p + Vector3(0, 4.6, 0), Vector3(2.0, 1.0, 2.0), leaf.lightened(0.08))


func _build_garage(st: SurfaceTool, body: StaticBody3D, c: Vector3, inner: float) -> void:
	# Open bus park: a loading shed along one side and parked danfos in bays.
	var shed := c + Vector3(-inner * 0.5 + 4.0, 0.15, 0)
	for z in [-18.0, -6.0, 6.0, 18.0]:
		MeshKit.box(st, shed + Vector3(0, 1.6, z), Vector3(0.25, 3.2, 0.25), Color(0.4, 0.4, 0.42))
	MeshKit.box(st, shed + Vector3(0, 3.3, 0), Vector3(6.0, 0.15, 40.0), Color(0.55, 0.35, 0.2))
	_add_box_collider(body, shed + Vector3(0, 1.6, 0), Vector3(0.5, 3.2, 40.0))
	var paints := Content.PAINTS.keys()
	for i in 3:
		var parked := BusVisual.new()
		add_child(parked)
		parked.build("classic14", paints[i % paints.size()], "")
		parked.position = c + Vector3(-12.0 + i * 5.0, 0.15 - BusVisual.GROUND_Y, 14.0 - i * 3.0)
		parked.rotation.y = 0.1 * i
		_add_box_collider(body, parked.position + Vector3(0, 0.6, 0), Vector3(1.9, 1.6, 4.6))
		for w in parked.wheels:
			w.position = Vector3.ZERO
		_place_parked_wheels(parked)


func _place_parked_wheels(parked: BusVisual) -> void:
	var positions := [Vector3(-0.78, -0.17, -1.23), Vector3(0.78, -0.17, -1.23), Vector3(-0.78, -0.17, 1.23), Vector3(0.78, -0.17, 1.23)]
	for i in parked.wheels.size():
		parked.wheels[i].position = positions[i]
		parked.wheels[i].rotation = Vector3(0, 0, PI * 0.5)


func _build_market(st: SurfaceTool, body: StaticBody3D, c: Vector3, inner: float) -> void:
	# Rows of stalls under bright canopies, leaving the pavement edge clear.
	for row in 5:
		for col in 6:
			var p := c + Vector3(-inner * 0.35 + col * (inner * 0.7 / 5.0), 0.15, -inner * 0.35 + row * (inner * 0.7 / 4.0))
			MeshKit.box(st, p + Vector3(0, 0.45, 0), Vector3(2.2, 0.9, 1.4), Color(0.45, 0.3, 0.18))
			var canopy: Color = AWNINGS[(row + col) % AWNINGS.size()]
			MeshKit.box(st, p + Vector3(0, 2.3, 0), Vector3(3.0, 0.1, 2.4), canopy)
			for corner in [Vector3(-1.3, 0, -1.0), Vector3(1.3, 0, 1.0)]:
				MeshKit.box(st, p + corner + Vector3(0, 1.15, 0), Vector3(0.08, 2.3, 0.08), Color(0.3, 0.3, 0.3))
			_add_box_collider(body, p + Vector3(0, 0.45, 0), Vector3(2.2, 0.9, 1.4))


func _build_outer_belt() -> void:
	var ext := layout.half_extent() + DistrictLayout.ROAD_WIDTH * 0.5
	for n: Vector3 in [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]:
		rng.seed = int(n.x * 31 + n.z * 17 + 99)
		var st := MeshKit.begin()
		var body := _static_body("OuterBelt")
		# The belt sits outside the ring road; its buildings face inward (-n).
		var strip_center := -n * (ext + 14.0)
		var span := (ext + 28.0) * 2.0
		var strip_size := Vector3(span, 0.15, 28.0) if absf(n.z) > 0.5 else Vector3(28.0, 0.15, span)
		MeshKit.box(st, strip_center + Vector3(0, 0.075, 0), strip_size, PAVEMENT)
		_add_box_collider(body, strip_center + Vector3(0, 0.075, 0), strip_size)
		_build_frontage(st, body, strip_center, n, 14.0 - DistrictLayout.SIDEWALK, span - 8.0)
		# Invisible boundary behind the belt.
		var wall_size := Vector3(span, 12.0, 2.0) if absf(n.z) > 0.5 else Vector3(2.0, 12.0, span)
		_add_box_collider(body, -n * (ext + 30.0) + Vector3(0, 6.0, 0), wall_size)
		add_child(MeshKit.mesh_instance(st, 0.9))


func _build_stops() -> void:
	var st := MeshKit.begin()
	for stop in layout.stops:
		for side in stop["sides"]:
			var wait: Vector3 = side["wait_point"]
			var dir: Vector3 = side["direction"]
			var right := RoadGraph.right_of(dir)
			var post := wait + right * 0.9 + dir * 2.2 + Vector3(0, 0.15, 0)
			MeshKit.box(st, post + Vector3(0, 1.2, 0), Vector3(0.1, 2.4, 0.1), Color(0.3, 0.3, 0.32))
			MeshKit.box(st, post + Vector3(0, 2.35, 0), Vector3(0.9, 0.4, 0.9) * Vector3(absf(dir.x) + 0.1, 1, absf(dir.z) + 0.1), Color(0.95, 0.8, 0.1))
			var label := Label3D.new()
			label.text = stop["name"]
			label.font_size = 48
			label.pixel_size = 0.008
			label.modulate = Color(0.08, 0.08, 0.08)
			label.outline_modulate = Color(0.95, 0.85, 0.2)
			label.outline_size = 10
			label.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
			label.position = post + Vector3(0, 3.0, 0)
			label.visibility_range_end = 120.0
			add_child(label)
	add_child(MeshKit.mesh_instance(st, 0.9))
