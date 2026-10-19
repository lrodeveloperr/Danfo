class_name CityBuilder
extends Node3D
## Builds the visible and collidable test district from a DistrictLayout,
## dressed to read as a Lagos mainland neighbourhood: crumbling roads with sand
## edges and potholes, open gutters, sun-faded and grime-streaked buildings,
## rusty roofs and water tanks, compound walls with painted warnings and
## unfinished frames. Roadside trade, crowds, wires and landmarks come from
## StreetDressing. Every block is one merged mesh (one draw call).
## Business names and painted messages are invented or generic.

const ASPHALT := Color(0.27, 0.27, 0.27)
const ASPHALT_OLD := Color(0.36, 0.35, 0.33)
const MARKING := Color(0.78, 0.76, 0.66)
const PAVEMENT := Color(0.6, 0.57, 0.52)
const LATERITE := Color(0.64, 0.41, 0.26)
const SAND := Color(0.74, 0.62, 0.47)
const GUTTER := Color(0.12, 0.12, 0.11)
const WALLS := [
	Color(0.9, 0.86, 0.76), Color(0.85, 0.76, 0.58), Color(0.66, 0.78, 0.82), Color(0.78, 0.84, 0.7),
	Color(0.88, 0.88, 0.85), Color(0.62, 0.6, 0.57), Color(0.86, 0.66, 0.58), Color(0.6, 0.7, 0.56),
	Color(0.58, 0.57, 0.55), Color(0.55, 0.54, 0.51), Color(0.93, 0.8, 0.55), Color(0.8, 0.6, 0.7),
]
const RUST := [Color(0.48, 0.27, 0.16), Color(0.56, 0.33, 0.19), Color(0.4, 0.24, 0.16), Color(0.5, 0.42, 0.36)]
const AWNINGS := [Color(0.1, 0.35, 0.7), Color(0.75, 0.12, 0.1), Color(0.1, 0.5, 0.25), Color(0.95, 0.75, 0.1), Color(0.9, 0.45, 0.1), Color(0.45, 0.1, 0.45)]
const BARS := Color(0.15, 0.15, 0.15)
const SHOP_NAMES := [
	"GOD'S GRACE PROVISIONS", "ADE & SONS AUTO PARTS", "BLESSED CHEMIST", "MAMA T BUKA",
	"NEW ERA TAILORING", "FAVOUR PHONE REPAIRS", "SEUN ELECTRICALS", "PEACE BARBING SALON",
	"EVERGREEN MINI MART", "TRUST GOD WELDING", "SWEET TASTE BAKERY", "UNITY VULCANISER",
	"MERCY FASHION HOME", "BOLA & CO PHOTOCOPY", "HOPE PAINTS & CHEMICALS", "DIVINE TOUCH SALON",
	"ALHAJI SPARE PARTS", "CHUKS & BROS ELECTRONICS", "OLUWA NI MO PRINTING", "EKO GLASS & ALUMINIUM",
	"NO WAHALA POS", "IYA BISI AMALA SPOT", "DESTINY CHILD NURSERY SCHOOL", "MIRACLE MECHANIC WORKSHOP",
]
const WALL_WRITING := [
	"THIS HOUSE IS NOT FOR SALE", "POST NO BILL", "NO PARKING", "NO URINATING HERE",
	"BEWARE OF 419", "THIS LAND IS NOT FOR SALE", "NO DUMPING OF REFUSE", "BEWARE OF DOG",
]

var layout: DistrictLayout
var rng := RandomNumberGenerator.new()
var dressing: StreetDressing
var options := {}
var _sign_index := 0


func build(district: DistrictLayout, build_options := {}) -> void:
	layout = district
	options = build_options
	rng.seed = 2026
	dressing = StreetDressing.new()
	dressing.name = "StreetDressing"
	add_child(dressing)
	dressing.setup(layout, options)
	_build_ground()
	_build_roads()
	for block in layout.blocks:
		_build_block(block)
	_build_outer_belt()
	_build_stops()
	dressing.build_shared()


func _static_body(name_: String) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = name_
	body.collision_layer = Bus.LAYER_WORLD
	body.collision_mask = 0
	add_child(body)
	return body


static func add_box_collider(body: StaticBody3D, center: Vector3, size: Vector3, rot := Basis.IDENTITY) -> void:
	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = size
	shape.shape = box
	shape.transform = Transform3D(rot, center)
	body.add_child(shape)


func _build_ground() -> void:
	var extent := layout.half_extent() + 320.0
	var body := _static_body("Ground")
	add_box_collider(body, Vector3(0, -0.5, 0), Vector3(extent * 2.0, 1.0, extent * 2.0))
	var st := MeshKit.begin()
	MeshKit.ground_quad(st, Vector3(-extent, 0, -extent), Vector3(extent, 0, -extent),
		Vector3(extent, 0, extent), Vector3(-extent, 0, extent), LATERITE.darkened(0.06))
	add_child(MeshKit.weathered_instance(st, 0.5, 0.0, 0.4))


func _build_roads() -> void:
	var st := MeshKit.begin()
	var hw := DistrictLayout.ROAD_WIDTH * 0.5
	for e in layout.graph.edges:
		var a := layout.graph.node_position(e.x)
		var b := layout.graph.node_position(e.y)
		var dir := (b - a).normalized()
		var right := RoadGraph.right_of(dir)
		var y := Vector3(0, 0.02, 0)
		var base: Color = ASPHALT if rng.randf() < 0.6 else ASPHALT_OLD
		MeshKit.ground_quad(st, a - right * hw + y, b - right * hw + y, b + right * hw + y, a + right * hw + y, base)
		var length := a.distance_to(b)
		var along_z := absf(dir.z) > 0.5
		# Crumbling edges: the asphalt breaks up into sand and laterite.
		for side: float in [-1.0, 1.0]:
			var d := hw + 2.0
			while d < length - hw - 2.0:
				var w := rng.randf_range(0.4, 1.6)
				var l := rng.randf_range(2.0, 7.0)
				var p := a + dir * (d + l * 0.5) + right * side * (hw - w * 0.5 + 0.05)
				var dust: Color = SAND if rng.randf() < 0.5 else LATERITE
				MeshKit.box(st, p + Vector3(0, 0.024, 0), _flat(along_z, l, w), dust.lerp(base, rng.randf_range(0.0, 0.35)))
				d += l + rng.randf_range(0.0, 6.0)
		# Worn centre line: broken and faded.
		var m := hw + 6.0
		while m < length - hw - 6.0:
			if rng.randf() < 0.65:
				MeshKit.box(st, a + dir * (m + 1.5) + Vector3(0, 0.027, 0), _flat(along_z, 3.0, 0.14), MARKING.lerp(base, rng.randf_range(0.2, 0.6)))
			m += 7.0
		# Potholes, patches and the odd puddle.
		for i in rng.randi_range(3, 7):
			var t := rng.randf_range(0.12, 0.88)
			var across := rng.randf_range(-hw + 1.2, hw - 1.2)
			var c := a.lerp(b, t) + right * across
			var kind := rng.randf()
			if kind < 0.55:
				for k in rng.randi_range(2, 4):
					var off := Vector3(rng.randf_range(-0.6, 0.6), 0, rng.randf_range(-0.6, 0.6))
					var sz := rng.randf_range(0.6, 1.5)
					MeshKit.box(st, c + off + Vector3(0, 0.028, 0), Vector3(sz, 0.006, sz * rng.randf_range(0.7, 1.3)), Color(0.13, 0.12, 0.11))
				if rng.randf() < 0.3:
					MeshKit.box(st, c + Vector3(0, 0.031, 0), Vector3(0.9, 0.004, 0.8), Color(0.35, 0.38, 0.4))
			else:
				var tone := base.darkened(0.3) if kind < 0.8 else base.lightened(0.15)
				MeshKit.box(st, c + Vector3(0, 0.026, 0), _flat(along_z, rng.randf_range(2.0, 5.0), rng.randf_range(1.5, 3.0)), tone)
	for id in layout.graph.positions:
		var p: Vector3 = layout.graph.node_position(id) + Vector3(0, 0.021, 0)
		MeshKit.ground_quad(st, p + Vector3(-hw, 0, -hw), p + Vector3(hw, 0, -hw), p + Vector3(hw, 0, hw), p + Vector3(-hw, 0, hw), ASPHALT_OLD)
		for k in 3:
			var off := Vector3(rng.randf_range(-hw + 1, hw - 1), 0.026, rng.randf_range(-hw + 1, hw - 1))
			MeshKit.box(st, p + off, Vector3(rng.randf_range(1, 3), 0.005, rng.randf_range(1, 3)), Color(0.18, 0.17, 0.16))
	var mi := MeshKit.weathered_instance(st, 0.55, 0.0, 0.3)
	mi.name = "Roads"
	add_child(mi)


## Flat box size with `along` running in the road's direction.
static func _flat(along_z: bool, along: float, across: float) -> Vector3:
	return Vector3(across, 0.006, along) if along_z else Vector3(along, 0.006, across)


func _build_block(block: Dictionary) -> void:
	rng.seed = int(block["seed"])
	var c: Vector3 = block["center"]
	var s: float = block["size"]
	var kind: String = block["kind"]
	var st := MeshKit.begin()
	var body := _static_body("Block")
	MeshKit.box(st, c + Vector3(0, 0.075, 0), Vector3(s, 0.15, s), PAVEMENT)
	add_box_collider(body, c + Vector3(0, 0.075, 0), Vector3(s, 0.15, s))
	var inner := s - DistrictLayout.SIDEWALK * 2.0
	MeshKit.box(st, c + Vector3(0, 0.152, 0), Vector3(inner, 0.004, inner), LATERITE)
	for n: Vector3 in [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]:
		_build_gutter(st, c - n * (s * 0.5 - 0.5), n, s - 1.0)
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
	for n: Vector3 in [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]:
		dressing.dress_pavement(st, body, c - n * s * 0.5, -n, s, kind)
	var mi := MeshKit.weathered_instance(st)
	mi.name = "BlockMesh"
	add_child(mi)


## Open concrete drain along a kerb line, partly slabbed over, with litter.
## `n` is the direction the line runs across (its length runs perpendicular).
func _build_gutter(st: SurfaceTool, line: Vector3, n: Vector3, length: float) -> void:
	var along := n.cross(Vector3.UP)
	MeshKit.box(st, line + Vector3(0, 0.158, 0), StreetDressing.oriented(n, length, 0.012, 0.65), GUTTER)
	var d := -length * 0.5 + 1.5
	while d < length * 0.5 - 1.5:
		var p := line + along * d
		var roll := rng.randf()
		if roll < 0.3:
			MeshKit.box(st, p + Vector3(0, 0.17, 0), StreetDressing.oriented(n, 1.4, 0.06, 0.8), PAVEMENT.darkened(0.15))
		elif roll < 0.6:
			var litter: Color = [Color(0.85, 0.85, 0.9), Color(0.2, 0.4, 0.8), Color(0.15, 0.15, 0.15), Color(0.8, 0.2, 0.2)][rng.randi() % 4]
			MeshKit.box(st, p + Vector3(rng.randf_range(-0.2, 0.2), 0.17, rng.randf_range(-0.2, 0.2)), Vector3(0.25, 0.05, 0.18), litter)
		d += rng.randf_range(1.5, 3.5)


## A row of buildings whose fronts face along `n`, at `front` from `origin`.
func _build_frontage(st: SurfaceTool, body: StaticBody3D, origin: Vector3, n: Vector3, front: float, span: float) -> void:
	var along := n.cross(Vector3.UP)
	var cursor := -span * 0.5
	while cursor < span * 0.5 - 6.0:
		var w := minf(rng.randf_range(7.0, 15.0), span * 0.5 - cursor)
		var roll := rng.randf()
		var front_center := origin + n * (front - 0.4) + along * (cursor + w * 0.5)
		if roll < 0.14:
			_compound(st, body, front_center, n, along, w)
		elif roll < 0.22:
			_unfinished(st, body, front_center, n, along, w)
		else:
			_shop_house(st, body, front_center, n, along, w)
		cursor += w + (rng.randf_range(0.8, 2.5) if rng.randf() < 0.3 else 0.0)


## Ground-floor shops with living space above: faded paint, burglar-proof
## window bars, balconies with washing, rust or concrete roof, water tank.
func _shop_house(st: SurfaceTool, body: StaticBody3D, front_center: Vector3, n: Vector3, along: Vector3, w: float) -> void:
	var depth := rng.randf_range(9.0, 13.0)
	var roll := rng.randf()
	var floors := 1 if roll < 0.3 else (2 if roll < 0.68 else (3 if roll < 0.92 else 4))
	var h := floors * 3.1 + 0.3
	var center := front_center - n * depth * 0.5 + Vector3(0, 0.15 + h * 0.5, 0)
	var size := StreetDressing.oriented(n, w, h, depth)
	var wall: Color = WALLS[rng.randi() % WALLS.size()]
	MeshKit.box(st, center, size, wall)
	add_box_collider(body, center, size)
	var top_y := 0.15 + h
	if floors <= 2 and rng.randf() < 0.7:
		# Corrugated iron roof, rusted, as a ribbed slab.
		var rust: Color = RUST[rng.randi() % RUST.size()]
		var ribs := int(w / 0.8)
		for k in ribs:
			var off := (k - (ribs - 1) * 0.5) * (w / ribs)
			var tone := rust.lightened(0.08) if k % 2 == 0 else rust.darkened(0.1)
			MeshKit.box(st, front_center - n * depth * 0.5 + along * off + Vector3(0, top_y + 0.12, 0),
				StreetDressing.oriented(n, w / ribs + 0.01, 0.14, depth + 0.6), tone)
	else:
		# Flat concrete roof with a parapet.
		MeshKit.box(st, center + Vector3(0, h * 0.5 + 0.35, 0), size * Vector3(1, 0, 1) + Vector3(0.1, 0.5, 0.1), wall.darkened(0.12))
	if rng.randf() < 0.55:
		var tank_at := front_center - n * depth * rng.randf_range(0.3, 0.7) + along * rng.randf_range(-w * 0.3, w * 0.3)
		MeshKit.prism(st, tank_at + Vector3(0, top_y + 0.4, 0), 0.65, 1.5, Color(0.07, 0.07, 0.08) if rng.randf() < 0.75 else Color(0.15, 0.3, 0.6), 8)
		MeshKit.box(st, tank_at + Vector3(0, top_y + 0.2, 0), Vector3(1.5, 0.4, 1.5), Color(0.3, 0.3, 0.3))
	_ground_floor(st, front_center, n, along, w, floors)
	for f in range(1, floors):
		var y := 0.15 + f * 3.1 + 1.55
		var count := maxi(1, int(w / 3.4))
		for k in count:
			var offset := (k - (count - 1) * 0.5) * (w / count)
			var win := front_center + n * 0.03 + along * offset + Vector3(0, y, 0)
			MeshKit.box(st, win, StreetDressing.oriented(n, 1.2, 1.3, 0.04), Color(0.1, 0.12, 0.13))
			for bar in 4:
				MeshKit.box(st, win + n * 0.04 + along * ((bar - 1.5) * 0.3), StreetDressing.oriented(n, 0.04, 1.35, 0.04), BARS)
			MeshKit.box(st, win + n * 0.04, StreetDressing.oriented(n, 1.25, 0.04, 0.04), BARS)
		if rng.randf() < 0.45:
			# Balcony with a rail and washing hung out to dry.
			var bal := front_center + n * 0.7 + Vector3(0, 0.15 + f * 3.1, 0)
			MeshKit.box(st, bal, StreetDressing.oriented(n, w * 0.7, 0.18, 1.4), wall.darkened(0.2))
			MeshKit.box(st, bal + n * 0.68 + Vector3(0, 0.55, 0), StreetDressing.oriented(n, w * 0.7, 0.06, 0.06), BARS)
			for k in rng.randi_range(2, 6):
				var cloth: Color = AWNINGS[rng.randi() % AWNINGS.size()].lightened(rng.randf_range(0.0, 0.4))
				MeshKit.box(st, bal + n * 0.6 + along * rng.randf_range(-w * 0.3, w * 0.3) + Vector3(0, 0.25, 0),
					StreetDressing.oriented(n, 0.5, 0.6, 0.03), cloth)
	if rng.randf() < 0.18:
		_paint_writing(front_center + n * 0.06 + Vector3(0, 0.15 + minf(h - 1.2, 4.6), 0), n, WALL_WRITING[rng.randi() % WALL_WRITING.size()])


func _ground_floor(st: SurfaceTool, front_center: Vector3, n: Vector3, along: Vector3, w: float, _floors: int) -> void:
	var face := front_center + n * 0.03
	if rng.randf() < 0.8:
		MeshKit.box(st, face + Vector3(0, 0.15 + 1.25, 0), StreetDressing.oriented(n, w * 0.75, 2.5, 0.05), Color(0.09, 0.09, 0.09))
		# Goods spilling out of the shop front.
		for k in rng.randi_range(2, 5):
			var goods: Color = AWNINGS[rng.randi() % AWNINGS.size()].lerp(Color(0.8, 0.75, 0.6), rng.randf())
			MeshKit.box(st, face + n * rng.randf_range(0.4, 1.4) + along * rng.randf_range(-w * 0.35, w * 0.35) + Vector3(0, 0.4, 0),
				Vector3(rng.randf_range(0.4, 0.9), rng.randf_range(0.4, 0.9), rng.randf_range(0.4, 0.8)), goods)
		var awning: Color = AWNINGS[rng.randi() % AWNINGS.size()]
		if rng.randf() < 0.6:
			MeshKit.box(st, face + n * 0.8 + Vector3(0, 0.15 + 2.7, 0), StreetDressing.oriented(n, w * 0.85, 0.08, 1.6), awning.darkened(0.15))
		var board := face + Vector3(0, 0.15 + 3.15, 0)
		MeshKit.box(st, board, StreetDressing.oriented(n, w * 0.85, 0.65, 0.06), Color(0.94, 0.92, 0.84).lerp(awning, rng.randf_range(0.0, 0.5)))
		if rng.randf() < 0.6:
			_add_sign(board + n * 0.05, n, SHOP_NAMES[_sign_index % SHOP_NAMES.size()], w * 0.8)
			_sign_index += 1
	else:
		MeshKit.box(st, face + Vector3(0, 0.15 + 1.1, 0), StreetDressing.oriented(n, 1.1, 2.1, 0.05), Color(0.35, 0.22, 0.12))


## A compound: perimeter wall and gate on the street line, house set back.
func _compound(st: SurfaceTool, body: StaticBody3D, front_center: Vector3, n: Vector3, along: Vector3, w: float) -> void:
	var wall_c: Color = WALLS[rng.randi() % WALLS.size()].darkened(0.1)
	var wall_h := 2.4
	var wall_center := front_center + Vector3(0, 0.15 + wall_h * 0.5, 0) - n * 0.1
	MeshKit.box(st, wall_center, StreetDressing.oriented(n, w, wall_h, 0.25), wall_c)
	add_box_collider(body, wall_center, StreetDressing.oriented(n, w, wall_h, 0.25))
	MeshKit.box(st, front_center + Vector3(0, 0.15 + 1.1, 0) + n * 0.05, StreetDressing.oriented(n, 3.0, 2.2, 0.08), Color(0.12, 0.2, 0.35) if rng.randf() < 0.5 else Color(0.3, 0.12, 0.1))
	# Broken bottles set along the top of the wall.
	var spikes := int(w / 0.5)
	for k in spikes:
		MeshKit.box(st, front_center + along * ((k - (spikes - 1) * 0.5) * 0.5) + Vector3(0, 0.15 + wall_h + 0.1, 0) - n * 0.1, Vector3(0.08, 0.2, 0.08), Color(0.25, 0.5, 0.3))
	var house_depth := 8.0
	var floors := rng.randi_range(1, 2)
	var h := floors * 3.1 + 0.3
	var hc := front_center - n * (4.0 + house_depth * 0.5) + Vector3(0, 0.15 + h * 0.5, 0)
	var size := StreetDressing.oriented(n, w * 0.8, h, house_depth)
	MeshKit.box(st, hc, size, WALLS[rng.randi() % WALLS.size()])
	add_box_collider(body, hc, size)
	MeshKit.box(st, hc + Vector3(0, h * 0.5 + 0.15, 0), size * Vector3(1, 0, 1) + Vector3(0.6, 0.25, 0.6), RUST[rng.randi() % RUST.size()])
	_paint_writing(front_center + n * 0.06 + Vector3(0, 0.15 + 1.5, 0) + along * w * 0.25, n, WALL_WRITING[rng.randi() % WALL_WRITING.size()])


## Unfinished building: concrete frame, bare columns and rebar on top.
func _unfinished(st: SurfaceTool, body: StaticBody3D, front_center: Vector3, n: Vector3, along: Vector3, w: float) -> void:
	var depth := 10.0
	var floors := rng.randi_range(2, 3)
	var concrete := Color(0.6, 0.6, 0.58)
	for f in floors:
		MeshKit.box(st, front_center - n * depth * 0.5 + Vector3(0, 0.15 + f * 3.1 + 0.1, 0), StreetDressing.oriented(n, w, 0.2, depth), concrete)
	for ax: float in [-0.45, 0.0, 0.45]:
		for dz: float in [0.1, 0.5, 0.9]:
			var col := front_center + along * (w * ax) - n * depth * dz
			MeshKit.box(st, col + Vector3(0, 0.15 + floors * 3.1 * 0.5, 0), Vector3(0.35, floors * 3.1, 0.35), concrete.darkened(0.08))
			for r in 4:
				var rod := col + Vector3((r % 2) * 0.2 - 0.1, 0.15 + floors * 3.1, (r / 2) * 0.2 - 0.1)
				MeshKit.segment(st, rod, rod + Vector3(rng.randf_range(-0.1, 0.1), 1.2, rng.randf_range(-0.1, 0.1)), 0.03, Color(0.35, 0.2, 0.12))
			add_box_collider(body, col + Vector3(0, 0.15 + floors * 3.1 * 0.5, 0), Vector3(0.35, floors * 3.1, 0.35))
	# Ground floor partly walled in with blocks, and a sand pile in front.
	MeshKit.box(st, front_center - n * 0.2 + Vector3(0, 0.15 + 0.9, 0), StreetDressing.oriented(n, w * 0.6, 1.8, 0.2), Color(0.55, 0.55, 0.53))
	MeshKit.box(st, front_center + n * 1.0 + Vector3(0, 0.15 + 0.4, 0), Vector3(2.0, 0.8, 2.0), SAND)


func _paint_writing(pos: Vector3, n: Vector3, text: String) -> void:
	var label := Label3D.new()
	label.text = text
	label.font_size = 64
	label.pixel_size = 0.006
	label.modulate = Color(0.55, 0.05, 0.05) if rng.randf() < 0.6 else Color(0.08, 0.08, 0.08)
	label.outline_size = 0
	label.transform = Transform3D(Basis.looking_at(-n, Vector3.UP), pos)
	label.double_sided = false
	label.visibility_range_end = 70.0
	add_child(label)


func _add_sign(pos: Vector3, n: Vector3, text: String, width: float) -> void:
	var label := Label3D.new()
	label.text = text
	label.font_size = 64
	label.pixel_size = clampf(width / (text.length() * 40.0), 0.003, 0.009)
	label.modulate = AWNINGS[rng.randi() % AWNINGS.size()].darkened(0.4)
	label.outline_size = 0
	# Label3D text faces +Z, so point +Z out towards the road.
	label.transform = Transform3D(Basis.looking_at(-n, Vector3.UP), pos)
	label.double_sided = false
	label.visibility_range_end = 90.0
	add_child(label)


func _build_trees(st: SurfaceTool, c: Vector3, s: float) -> void:
	for i in 4:
		if rng.randf() < 0.45:
			continue
		var edge := s * 0.5 - 1.6
		var side := rng.randi() % 4
		var t := rng.randf_range(-edge * 0.85, edge * 0.85)
		var p := c + Vector3([edge, -edge, t, t][side], 0.15, [t, t, edge, -edge][side])
		if rng.randf() < 0.4:
			# Palm: tall bare trunk, fronds at the top.
			var height := rng.randf_range(6.0, 9.0)
			var lean := Vector3(rng.randf_range(-0.6, 0.6), 0, rng.randf_range(-0.6, 0.6))
			MeshKit.segment(st, p, p + Vector3(0, height, 0) + lean, 0.3, Color(0.42, 0.36, 0.28))
			var crown := p + Vector3(0, height, 0) + lean
			for k in 7:
				var ang := TAU * k / 7.0
				var tip := crown + Vector3(cos(ang) * 2.4, -1.0, sin(ang) * 2.4)
				MeshKit.segment(st, crown, tip, 0.35, Color(0.25, 0.42, 0.16).lerp(Color(0.45, 0.42, 0.2), rng.randf() * 0.4))
		else:
			MeshKit.box(st, p + Vector3(0, 1.5, 0), Vector3(0.4, 3.0, 0.4), Color(0.35, 0.25, 0.16))
			var leaf := Color(0.2, 0.38, 0.14).lerp(Color(0.38, 0.45, 0.2), rng.randf())
			MeshKit.box(st, p + Vector3(0, 3.7, 0), Vector3(3.6, 1.8, 3.4), leaf)
			MeshKit.box(st, p + Vector3(0.4, 4.8, -0.3), Vector3(2.4, 1.2, 2.4), leaf.lightened(0.07))


func _build_garage(st: SurfaceTool, body: StaticBody3D, c: Vector3, inner: float) -> void:
	# Motor park: rusty loading sheds and rows of danfos in bays.
	for row in 3:
		var shed := c + Vector3(-inner * 0.5 + 6.0 + row * 24.0, 0.15, 0)
		for z: float in [-24.0, -12.0, 0.0, 12.0, 24.0]:
			MeshKit.box(st, shed + Vector3(0, 1.7, z), Vector3(0.18, 3.4, 0.18), Color(0.35, 0.33, 0.32))
		var ribs := 24
		for k in ribs:
			MeshKit.box(st, shed + Vector3(0, 3.45, -26.0 + k * (52.0 / ribs)), Vector3(7.0, 0.1, 52.0 / ribs + 0.02), RUST[k % RUST.size()])
		add_box_collider(body, shed + Vector3(0, 1.7, 0), Vector3(0.4, 3.4, 50.0))
	var paints := Content.PAINTS.keys()
	var slogans := ["GOD DEY", "", "NO FOOD FOR LAZY MAN", "", "SURU LERE", "", ""]
	for i in 7:
		var parked := BusVisual.new()
		add_child(parked)
		parked.build("classic14", paints[i % paints.size()], slogans[i], rng.randf_range(0.35, 0.95), rng.randi())
		var row := i % 3
		parked.position = c + Vector3(-inner * 0.5 + 12.0 + row * 24.0, 0.15 - BusVisual.GROUND_Y, -20.0 + (i / 3) * 14.0 + rng.randf_range(-1.5, 1.5))
		parked.rotation.y = rng.randf_range(-0.15, 0.15)
		parked.park_wheels()
		add_box_collider(body, parked.position + Vector3(0, 0.6, 0), Vector3(1.9, 1.6, 4.6), Basis(Vector3.UP, parked.rotation.y))
		dressing.add_crowd_point(parked.position + Vector3(1.6, -0.36, rng.randf_range(-1, 1)), rng.randf() < 0.3)


func _build_market(st: SurfaceTool, body: StaticBody3D, c: Vector3, inner: float) -> void:
	# Dense market: rows of stalls under umbrellas and rusty sheds.
	for row in 7:
		for col in 9:
			var p := c + Vector3(-inner * 0.42 + col * (inner * 0.84 / 8.0), 0.15, -inner * 0.42 + row * (inner * 0.84 / 6.0))
			p += Vector3(rng.randf_range(-1.2, 1.2), 0, rng.randf_range(-1.2, 1.2))
			MeshKit.box(st, p + Vector3(0, 0.45, 0), Vector3(2.0, 0.9, 1.3), Color(0.42, 0.29, 0.18))
			for k in 4:
				var goods: Color = AWNINGS[rng.randi() % AWNINGS.size()].lerp(Color(0.85, 0.7, 0.4), rng.randf())
				MeshKit.box(st, p + Vector3(rng.randf_range(-0.7, 0.7), 1.0, rng.randf_range(-0.4, 0.4)), Vector3(0.4, 0.2, 0.35), goods)
			if (row + col) % 3 == 0:
				MeshKit.box(st, p + Vector3(0, 2.4, 0), Vector3(3.2, 0.1, 2.6), RUST[(row * 3 + col) % RUST.size()])
				for corner: Vector3 in [Vector3(-1.4, 0, -1.1), Vector3(1.4, 0, 1.1), Vector3(-1.4, 0, 1.1), Vector3(1.4, 0, -1.1)]:
					MeshKit.box(st, p + corner + Vector3(0, 1.2, 0), Vector3(0.08, 2.4, 0.08), Color(0.35, 0.3, 0.25))
			else:
				var a: Color = AWNINGS[rng.randi() % AWNINGS.size()]
				MeshKit.umbrella(st, p + Vector3(rng.randf_range(-0.3, 0.3), 0, 0), 1.6, 2.2, a, Color(0.95, 0.95, 0.92) if rng.randf() < 0.5 else a.darkened(0.2))
			add_box_collider(body, p + Vector3(0, 0.45, 0), Vector3(2.0, 0.9, 1.3))
			dressing.add_crowd_point(p + Vector3(rng.randf_range(-1.5, 1.5), 0, 1.2), rng.randf() < 0.3)
			if rng.randf() < 0.5:
				dressing.add_crowd_point(p + Vector3(rng.randf_range(-1.5, 1.5), 0, -1.2), rng.randf() < 0.2)


func _build_outer_belt() -> void:
	var ext := layout.half_extent() + DistrictLayout.ROAD_WIDTH * 0.5
	for n: Vector3 in [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]:
		rng.seed = int(n.x * 31 + n.z * 17 + 99)
		var st := MeshKit.begin()
		var body := _static_body("OuterBelt")
		# The belt sits outside the ring road; its buildings face inward (+n).
		var strip_center := -n * (ext + 14.0)
		var span := (ext + 28.0) * 2.0
		var strip_size := StreetDressing.oriented(n, span, 0.15, 28.0)
		MeshKit.box(st, strip_center + Vector3(0, 0.075, 0), strip_size, PAVEMENT)
		add_box_collider(body, strip_center + Vector3(0, 0.075, 0), strip_size)
		var kerb := strip_center + n * 14.0
		_build_gutter(st, kerb - n * 0.5, n, span)
		_build_frontage(st, body, strip_center, n, 14.0 - DistrictLayout.SIDEWALK, span - 8.0)
		dressing.dress_pavement(st, body, kerb, n, span - 8.0, "belt")
		add_box_collider(body, -n * (ext + 30.0) + Vector3(0, 6.0, 0), StreetDressing.oriented(n, span, 12.0, 2.0))
		add_child(MeshKit.weathered_instance(st))


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
			# A crowd waits at every stop.
			for k in rng.randi_range(4, 9):
				dressing.add_crowd_point(wait + dir * rng.randf_range(-5.0, 5.0) + right * rng.randf_range(0.2, 1.8), rng.randf() < 0.25)
	add_child(MeshKit.weathered_instance(st))
