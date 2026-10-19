class_name StreetDressing
extends Node3D
## The hustle on and above the pavement: umbrella stalls, kiosks, container
## shops, vulcanizers with tyre stacks, generators, refuse heaps and okada
## ranks; leaning poles with sagging, tangled wires; junction billboards with
## invented brands; footbridges; a flyover with trade under it; and instanced
## crowds (two draw calls for every person in the district).

const CLOTHES := [
	Color(0.85, 0.2, 0.15), Color(0.1, 0.45, 0.25), Color(0.95, 0.95, 0.92), Color(0.2, 0.3, 0.7),
	Color(0.9, 0.6, 0.1), Color(0.55, 0.1, 0.45), Color(0.12, 0.12, 0.12), Color(0.0, 0.55, 0.6),
	Color(0.95, 0.8, 0.2), Color(0.6, 0.35, 0.15), Color(0.75, 0.75, 0.78), Color(0.3, 0.6, 0.3),
]
const BRANDS := [
	["OYA DATA", "5G FOR EVERY STREET"], ["SUNRISE MALT", "ENERGY FOR THE HUSTLE"],
	["EKO NOODLES", "READY IN 3 MINUTES"], ["PAPA BEST CEMENT", "BUILD AM STRONG"],
	["SWIFTCASH POS", "SEND MONEY SHARP SHARP"], ["KAKAKI PAINTS", "COLOUR YOUR HOUSE"],
	["ZOBO KING", "COLD ONE FOR YOU"], ["TRUSTLINE MOBILE", "CALL ANYBODY, ANYTIME"],
]
const POLE_GAP := 28.0

var layout: DistrictLayout
var options := {}
var rng := RandomNumberGenerator.new()
var crowd_points: Array[Dictionary] = []
var _util := MeshKit.begin()
var _util_body: StaticBody3D
var _avoid: Array[Vector3] = []


## Box size for something whose width runs along a kerb line facing `n`.
static func oriented(n: Vector3, w: float, h: float, d: float) -> Vector3:
	return Vector3(w, h, d) if absf(n.z) > 0.5 else Vector3(d, h, w)


func setup(district: DistrictLayout, build_options: Dictionary) -> void:
	layout = district
	options = build_options
	rng.seed = 1960
	_util_body = StaticBody3D.new()
	_util_body.collision_layer = Bus.LAYER_WORLD
	_util_body.collision_mask = 0
	add_child(_util_body)
	for stop in layout.stops:
		for side in stop["sides"]:
			_avoid.append(side["wait_point"])


func add_crowd_point(pos: Vector3, with_load: bool) -> void:
	crowd_points.append({"pos": pos, "load": with_load})


func _near_stop(p: Vector3, radius := 7.0) -> bool:
	for a in _avoid:
		if Vector3(a.x, 0, a.z).distance_to(Vector3(p.x, 0, p.z)) < radius:
			return true
	return false


## Fills a pavement strip. `kerb` is the middle of the kerb line, `out` points
## from the pavement towards the road, `length` runs along the kerb.
func dress_pavement(st: SurfaceTool, body: StaticBody3D, kerb: Vector3, out: Vector3, length: float, kind: String) -> void:
	var along := out.cross(Vector3.UP)
	var base_y := 0.15
	var d := -length * 0.5 + 8.0
	while d < length * 0.5 - 8.0:
		var depth := rng.randf_range(1.2, 2.4)
		var p := kerb - out * depth + along * d + Vector3(0, base_y, 0)
		var step := rng.randf_range(2.5, 6.0)
		if _near_stop(p):
			d += step
			continue
		var roll := rng.randf()
		if kind == "garage" or kind == "market":
			roll *= 0.6 # busier edges
		if roll < 0.24:
			_umbrella_stall(st, body, p, out, along)
		elif roll < 0.34:
			_kiosk(st, body, p, out)
		elif roll < 0.39:
			_container_shop(st, body, kerb - out * 1.6 + along * d + Vector3(0, base_y, 0), out)
			step += 4.0
		elif roll < 0.44:
			_vulcanizer(st, p, out, along)
		elif roll < 0.5:
			_table_hawker(st, p, out, along)
		elif roll < 0.55:
			_generator_spot(st, p, out, along)
		elif roll < 0.6:
			_refuse_heap(st, p)
		elif roll < 0.66:
			_okada_rank(st, kerb - out * 1.3 + along * d + Vector3(0, base_y, 0), along)
		elif roll < 0.8:
			for k in rng.randi_range(1, 3):
				add_crowd_point(p + along * rng.randf_range(-1.5, 1.5) + out * rng.randf_range(-0.5, 0.8), rng.randf() < 0.2)
		d += step
	_poles_along(kerb - out * 0.95 + Vector3(0, base_y, 0), along, length)


func _umbrella_stall(st: SurfaceTool, body: StaticBody3D, p: Vector3, out: Vector3, along: Vector3) -> void:
	var a: Color = CityBuilder.AWNINGS[rng.randi() % CityBuilder.AWNINGS.size()]
	var b: Color = Color(0.95, 0.95, 0.92) if rng.randf() < 0.5 else a.darkened(0.25)
	MeshKit.umbrella(st, p, rng.randf_range(1.3, 1.8), 2.1, a, b)
	MeshKit.box(st, p + Vector3(0, 0.4, 0) + out * 0.3, oriented(out, 1.6, 0.8, 0.9), Color(0.45, 0.31, 0.2))
	for k in rng.randi_range(3, 6):
		var goods: Color = CityBuilder.AWNINGS[rng.randi() % CityBuilder.AWNINGS.size()].lerp(Color(0.85, 0.7, 0.4), rng.randf())
		MeshKit.box(st, p + out * 0.3 + along * rng.randf_range(-0.6, 0.6) + Vector3(0, 0.88, 0), Vector3(0.3, rng.randf_range(0.1, 0.3), 0.3), goods)
	MeshKit.box(st, p - out * 0.6 + Vector3(0, 0.22, 0), Vector3(0.4, 0.45, 0.4), Color(0.2, 0.4, 0.75))
	CityBuilder.add_box_collider(body, p + Vector3(0, 0.4, 0) + out * 0.3, oriented(out, 1.6, 0.8, 0.9))
	add_crowd_point(p - out * 0.7 + along * 0.6, false)
	if rng.randf() < 0.6:
		add_crowd_point(p + out * 1.2 + along * rng.randf_range(-0.8, 0.8), rng.randf() < 0.3)


func _kiosk(st: SurfaceTool, body: StaticBody3D, p: Vector3, out: Vector3) -> void:
	var colors := [Color(0.9, 0.75, 0.1), Color(0.15, 0.45, 0.75), Color(0.75, 0.2, 0.15), Color(0.2, 0.55, 0.3), Color(0.85, 0.85, 0.82)]
	var c: Color = colors[rng.randi() % colors.size()]
	MeshKit.box(st, p + Vector3(0, 1.1, 0), Vector3(1.8, 2.2, 1.8), c)
	MeshKit.box(st, p + Vector3(0, 1.25, 0) + out * 0.91, oriented(out, 1.4, 0.8, 0.02), Color(0.08, 0.08, 0.08))
	MeshKit.box(st, p + Vector3(0, 2.3, 0) + out * 0.2, Vector3(2.4, 0.08, 2.4), CityBuilder.RUST[rng.randi() % CityBuilder.RUST.size()])
	CityBuilder.add_box_collider(body, p + Vector3(0, 1.1, 0), Vector3(1.8, 2.2, 1.8))
	add_crowd_point(p + out * 1.4, false)


func _container_shop(st: SurfaceTool, body: StaticBody3D, p: Vector3, out: Vector3) -> void:
	var colors := [Color(0.75, 0.15, 0.1), Color(0.1, 0.35, 0.6), Color(0.2, 0.5, 0.3), Color(0.85, 0.6, 0.1), Color(0.5, 0.5, 0.52)]
	var c: Color = colors[rng.randi() % colors.size()]
	var size := oriented(out, 6.0, 2.6, 2.4)
	MeshKit.box(st, p + Vector3(0, 1.3, 0), size, c)
	var along := out.cross(Vector3.UP)
	for k in 12:
		MeshKit.box(st, p + along * (k - 5.5) * 0.5 + Vector3(0, 1.3, 0) + out * 1.21, oriented(out, 0.08, 2.4, 0.02), c.darkened(0.25))
	MeshKit.box(st, p + Vector3(0, 1.15, 0) + out * 1.23, oriented(out, 2.4, 2.1, 0.02), Color(0.08, 0.08, 0.08))
	CityBuilder.add_box_collider(body, p + Vector3(0, 1.3, 0), size)
	add_crowd_point(p + out * 1.9, false)


func _vulcanizer(st: SurfaceTool, p: Vector3, out: Vector3, along: Vector3) -> void:
	for stack in rng.randi_range(1, 3):
		var base := p + along * (stack - 1) * 0.9
		for t in rng.randi_range(3, 7):
			MeshKit.prism(st, base + Vector3(0, t * 0.22, 0), 0.36, 0.2, Color(0.06, 0.06, 0.06), 8)
	MeshKit.box(st, p + out * 0.8 + Vector3(0, 0.35, 0), Vector3(0.7, 0.7, 0.5), Color(0.75, 0.15, 0.1))
	MeshKit.prism(st, p - along * 1.2, 0.3, 0.9, Color(0.2, 0.3, 0.6), 8)
	add_crowd_point(p + out * 1.3 + along * 0.5, false)


func _table_hawker(st: SurfaceTool, p: Vector3, out: Vector3, along: Vector3) -> void:
	MeshKit.box(st, p + Vector3(0, 0.38, 0), oriented(out, 1.2, 0.76, 0.7), Color(0.5, 0.36, 0.22))
	for k in 5:
		MeshKit.box(st, p + along * rng.randf_range(-0.45, 0.45) + Vector3(0, 0.82, 0), Vector3(0.2, 0.12, 0.2), Color(0.95, 0.55, 0.1).lerp(Color(0.2, 0.6, 0.2), rng.randf()))
	add_crowd_point(p - out * 0.6, false)


func _generator_spot(st: SurfaceTool, p: Vector3, out: Vector3, along: Vector3) -> void:
	var gen: Color = [Color(0.85, 0.65, 0.05), Color(0.75, 0.15, 0.1), Color(0.2, 0.35, 0.6)][rng.randi() % 3]
	MeshKit.box(st, p + Vector3(0, 0.3, 0), Vector3(0.75, 0.6, 0.55), gen)
	MeshKit.box(st, p + Vector3(0, 0.62, 0), Vector3(0.5, 0.06, 0.4), Color(0.1, 0.1, 0.1))
	MeshKit.segment(st, p + Vector3(0, 0.3, 0), p + along * 3.0 + Vector3(0, 0.05, 0), 0.03, Color(0.05, 0.05, 0.05))
	for k in 2:
		var chair := p + along * (1.0 + k * 0.7) + out * 0.5
		MeshKit.box(st, chair + Vector3(0, 0.22, 0), Vector3(0.45, 0.05, 0.45), Color(0.9, 0.9, 0.9) if rng.randf() < 0.5 else Color(0.2, 0.35, 0.7))
		MeshKit.box(st, chair + Vector3(0, 0.45, 0) - out * 0.2, oriented(out, 0.45, 0.45, 0.05), Color(0.9, 0.9, 0.9))
		if rng.randf() < 0.6:
			add_crowd_point(chair, false)


func _refuse_heap(st: SurfaceTool, p: Vector3) -> void:
	var junk := [Color(0.15, 0.15, 0.15), Color(0.85, 0.85, 0.9), Color(0.2, 0.4, 0.8), Color(0.45, 0.35, 0.2), Color(0.8, 0.2, 0.2), Color(0.3, 0.45, 0.2)]
	for k in rng.randi_range(8, 16):
		var off := Vector3(rng.randf_range(-1.0, 1.0), 0, rng.randf_range(-1.0, 1.0))
		var s := rng.randf_range(0.2, 0.55)
		MeshKit.box(st, p + off + Vector3(0, s * 0.4 + (1.0 - off.length()) * 0.25, 0), Vector3(s, s * 0.8, s), junk[rng.randi() % junk.size()])


func _okada_rank(st: SurfaceTool, p: Vector3, along: Vector3) -> void:
	for k in rng.randi_range(2, 5):
		var bike := p + along * (k * 1.0)
		okada_mesh(st, bike, along.rotated(Vector3.UP, rng.randf_range(-0.4, 0.4)), rng)
		if rng.randf() < 0.5:
			add_crowd_point(bike + along.cross(Vector3.UP) * 0.7, false)


## A motorcycle taxi: frame, tank, seat, wheels.
static func okada_mesh(st: SurfaceTool, base: Vector3, facing: Vector3, r: RandomNumberGenerator) -> void:
	var colors := [Color(0.1, 0.1, 0.1), Color(0.6, 0.05, 0.05), Color(0.1, 0.2, 0.5), Color(0.5, 0.5, 0.52)]
	var c: Color = colors[r.randi() % colors.size()]
	var rot := Basis.looking_at(facing, Vector3.UP)
	MeshKit.box(st, base + Vector3(0, 0.55, 0), Vector3(0.28, 0.35, 1.3), c, rot)
	MeshKit.box(st, base + Vector3(0, 0.78, 0) + rot * Vector3(0, 0, 0.2), Vector3(0.3, 0.1, 0.8), Color(0.08, 0.08, 0.08), rot)
	for z: float in [-0.65, 0.65]:
		MeshKit.box(st, base + Vector3(0, 0.3, 0) + rot * Vector3(0, 0, z), Vector3(0.12, 0.6, 0.6), Color(0.05, 0.05, 0.05), rot)
	MeshKit.box(st, base + Vector3(0, 0.95, 0) + rot * Vector3(0, 0, -0.6), Vector3(0.7, 0.05, 0.05), Color(0.3, 0.3, 0.3), rot)


## Leaning concrete poles with crossarms; tangled wires sag between them.
func _poles_along(start_mid: Vector3, along: Vector3, length: float) -> void:
	var tops: Array[Vector3] = []
	var d := -length * 0.5 + 6.0
	while d < length * 0.5 - 6.0:
		var base := start_mid + along * d
		if not _near_stop(base, 4.0):
			var lean := Vector3(rng.randf_range(-0.35, 0.35), 0, rng.randf_range(-0.35, 0.35))
			var top := base + Vector3(0, rng.randf_range(7.5, 9.0), 0) + lean
			MeshKit.segment(_util, base, top, 0.24, Color(0.55, 0.54, 0.5))
			MeshKit.segment(_util, top - along * 0.9 + Vector3(0, -0.3, 0), top + along * 0.9 + Vector3(0, -0.3, 0), 0.1, Color(0.25, 0.25, 0.25))
			if rng.randf() < 0.15:
				MeshKit.box(_util, top + Vector3(0, -2.4, 0) + along.cross(Vector3.UP) * 0.5, Vector3(0.7, 1.0, 0.6), Color(0.35, 0.37, 0.35))
			CityBuilder.add_box_collider(_util_body, (base + top) * 0.5, Vector3(0.3, top.y - base.y, 0.3))
			tops.append(top)
		d += POLE_GAP + rng.randf_range(-4.0, 4.0)
	for i in range(1, tops.size()):
		var a := tops[i - 1]
		var b := tops[i]
		for w in rng.randi_range(2, 4):
			var off := along.cross(Vector3.UP) * rng.randf_range(-0.8, 0.8) + Vector3(0, -0.3 - w * 0.25, 0)
			MeshKit.wire(_util, a + off, b + off, rng.randf_range(0.4, 1.2), Color(0.05, 0.05, 0.05))
		if rng.randf() < 0.3:
			# A stray service cable down to a building.
			var drop := b + along.cross(Vector3.UP) * rng.randf_range(4.0, 7.0) + Vector3(0, -3.5, 0)
			MeshKit.wire(_util, b, drop, 0.5, Color(0.05, 0.05, 0.05), 4)


func build_shared() -> void:
	_build_billboards()
	_build_footbridges()
	_build_flyover()
	var util := MeshKit.weathered_instance(_util, 0.4, 0.2, 0.2)
	util.name = "Utilities"
	add_child(util)
	_build_crowds()


func _build_billboards() -> void:
	var st := MeshKit.begin()
	var corners := [Vector2i(1, 1), Vector2i(3, 1), Vector2i(2, 2), Vector2i(1, 3), Vector2i(3, 3), Vector2i(0, 0), Vector2i(4, 4), Vector2i(4, 0)]
	for i in corners.size():
		var node := DistrictLayout.node_pos(corners[i].x, corners[i].y)
		var diag := Vector3(1 if i % 2 == 0 else -1, 0, 1 if (i / 2) % 2 == 0 else -1)
		var p := node + diag * (DistrictLayout.ROAD_WIDTH * 0.5 + 5.0) + Vector3(0, 0.15, 0)
		var face := -Vector3(diag.x, 0, 0) if i % 3 == 0 else -Vector3(0, 0, diag.z)
		var along := face.cross(Vector3.UP)
		for side: float in [-1.5, 1.5]:
			MeshKit.box(st, p + along * side + Vector3(0, 3.5, 0), Vector3(0.3, 7.0, 0.3), Color(0.3, 0.3, 0.32))
		var panel := p + Vector3(0, 8.5, 0)
		var colors := [Color(0.95, 0.75, 0.1), Color(0.1, 0.4, 0.75), Color(0.75, 0.12, 0.1), Color(0.1, 0.55, 0.3), Color(0.95, 0.95, 0.92)]
		var c: Color = colors[i % colors.size()]
		MeshKit.box(st, panel, oriented(face, 9.0, 3.6, 0.3), Color(0.15, 0.15, 0.15))
		MeshKit.box(st, panel + face * 0.17, oriented(face, 8.6, 3.2, 0.04), c)
		MeshKit.segment(st, panel + face * 0.6 + Vector3(0, 2.0, 0) - along * 3.0, panel + face * 0.6 + Vector3(0, 2.0, 0) + along * 3.0, 0.08, Color(0.2, 0.2, 0.2))
		var brand: Array = BRANDS[i % BRANDS.size()]
		var ink := Color(0.08, 0.08, 0.08) if c.get_luminance() > 0.5 else Color(0.97, 0.97, 0.95)
		_label(brand[0], panel + face * 0.22 + Vector3(0, 0.55, 0), face, 0.02, ink)
		_label(brand[1], panel + face * 0.22 + Vector3(0, -0.75, 0), face, 0.011, ink)
	add_child(MeshKit.weathered_instance(st, 0.35, 0.25, 0.15))


func _label(text: String, pos: Vector3, face: Vector3, pixel: float, color: Color) -> void:
	var l := Label3D.new()
	l.text = text
	l.font_size = 64
	l.pixel_size = pixel
	l.modulate = color
	l.outline_size = 0
	l.transform = Transform3D(Basis.looking_at(-face, Vector3.UP), pos)
	l.double_sided = false
	l.visibility_range_end = 220.0
	add_child(l)


## Steel footbridges over the road with stair towers and banner ads.
func _build_footbridges() -> void:
	var st := MeshKit.begin()
	for pair in [[Vector2i(1, 1), Vector2i(1, 2)], [Vector2i(3, 2), Vector2i(4, 2)]]:
		var a := DistrictLayout.node_pos(pair[0].x, pair[0].y)
		var b := DistrictLayout.node_pos(pair[1].x, pair[1].y)
		var mid := (a + b) * 0.5 + (b - a).normalized() * 18.0
		var dir := (b - a).normalized()
		var across := RoadGraph.right_of(dir)
		var span := DistrictLayout.ROAD_WIDTH + 6.0
		var deck_y := 5.8
		var green := Color(0.25, 0.42, 0.3)
		var x_span := absf(across.x) > 0.5
		MeshKit.box(st, mid + Vector3(0, deck_y, 0), Vector3(span, 0.3, 2.4) if x_span else Vector3(2.4, 0.3, span), Color(0.45, 0.45, 0.45))
		for rail: float in [-1.15, 1.15]:
			var r := mid + dir * rail + Vector3(0, deck_y + 0.8, 0)
			MeshKit.segment(st, r - across * span * 0.5, r + across * span * 0.5, 0.08, green)
			var banner: Color = CityBuilder.AWNINGS[rng.randi() % CityBuilder.AWNINGS.size()]
			MeshKit.box(st, mid + dir * rail * 1.02 + Vector3(0, deck_y + 0.5, 0), Vector3(span * 0.7, 0.9, 0.04) if x_span else Vector3(0.04, 0.9, span * 0.7), banner)
		for side: float in [-1.0, 1.0]:
			var tower := mid + across * side * (span * 0.5 + 1.0) + Vector3(0, 0.15, 0)
			MeshKit.box(st, tower + Vector3(0, deck_y * 0.5, 0), Vector3(2.6, deck_y, 2.6), green.darkened(0.2))
			for k in 4:
				MeshKit.segment(st, tower + Vector3(-1.4, k * 1.5, -1.4), tower + Vector3(1.4, k * 1.5 + 1.5, 1.4), 0.12, Color(0.4, 0.4, 0.4))
			CityBuilder.add_box_collider(_util_body, tower + Vector3(0, deck_y * 0.5, 0), Vector3(2.6, deck_y, 2.6))
			for k in 3:
				add_crowd_point(tower - Vector3(0, 0.15, 0) + across * side * 2.0 + dir * rng.randf_range(-1.5, 1.5), false)
	add_child(MeshKit.weathered_instance(st, 0.5, 0.35, 0.2))


## Concrete flyover across the district above the third row of roads; the
## "Under Bridge" stop and its traders sit beneath it.
func _build_flyover() -> void:
	var st := MeshKit.begin()
	var z := DistrictLayout.node_pos(0, 3).z
	var deck_y := 14.0
	var length := 1100.0
	var concrete := Color(0.62, 0.61, 0.58)
	MeshKit.box(st, Vector3(0, deck_y, z), Vector3(length, 1.2, 17.0), concrete)
	for side: float in [-1.0, 1.0]:
		MeshKit.box(st, Vector3(0, deck_y + 1.1, z + side * 8.3), Vector3(length, 1.0, 0.4), concrete.darkened(0.08))
	var hw := layout.half_extent()
	var x := -length * 0.5 + 15.0
	while x < length * 0.5:
		var near_junction := false
		for ix in DistrictLayout.GRID:
			if absf(x - DistrictLayout.node_pos(ix, 0).x) < 12.0:
				near_junction = true
		var inside := absf(x) < hw + 6.0
		var in_belt := absf(x) > hw + 6.0 and absf(x) < hw + 40.0
		if not near_junction and not in_belt:
			if inside:
				for side: float in [-1.0, 1.0]:
					var pz := z + side * (DistrictLayout.ROAD_WIDTH * 0.5 + 1.4)
					MeshKit.box(st, Vector3(x, deck_y * 0.5, pz), Vector3(1.4, deck_y, 1.4), concrete.darkened(0.05))
					CityBuilder.add_box_collider(_util_body, Vector3(x, deck_y * 0.5, pz), Vector3(1.4, deck_y, 1.4))
				MeshKit.box(st, Vector3(x, deck_y - 1.0, z), Vector3(1.8, 1.0, 17.0), concrete.darkened(0.1))
			else:
				MeshKit.box(st, Vector3(x, deck_y * 0.5, z), Vector3(2.0, deck_y, 3.0), concrete.darkened(0.05))
		x += 30.0
	# Lamp posts along the deck.
	x = -length * 0.5
	while x < length * 0.5:
		MeshKit.box(st, Vector3(x, deck_y + 4.0, z), Vector3(0.2, 7.0, 0.2), Color(0.4, 0.4, 0.42))
		x += 40.0
	add_child(MeshKit.weathered_instance(st, 0.6, 0.55, 0.25))
	# Shade under the deck.
	var plane := PlaneMesh.new()
	plane.size = Vector2(length, 21.0)
	var shade_mat := StandardMaterial3D.new()
	shade_mat.albedo_color = Color(0, 0, 0, 0.38)
	shade_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	shade_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	var shade := MeshInstance3D.new()
	shade.mesh = plane
	shade.material_override = shade_mat
	shade.position = Vector3(0, 0.2, z)
	add_child(shade)
	for k in 30:
		var px := rng.randf_range(-hw, hw)
		for side: float in [-1.0, 1.0]:
			var p := Vector3(px, 0.15, z + side * (DistrictLayout.ROAD_WIDTH * 0.5 + rng.randf_range(0.8, 2.6)))
			if not _near_stop(p, 3.0):
				add_crowd_point(p, rng.randf() < 0.35)


func _build_crowds() -> void:
	var plain: Array[Dictionary] = []
	var loaded: Array[Dictionary] = []
	for c in crowd_points:
		(loaded if c["load"] else plain).append(c)
	add_child(_crowd_multimesh(_person_mesh(false), plain))
	add_child(_crowd_multimesh(_person_mesh(true), loaded))


func _crowd_multimesh(mesh: ArrayMesh, points: Array[Dictionary]) -> MultiMeshInstance3D:
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.use_custom_data = true
	# White instance colours keep the vertex colours intact (the Compatibility
	# renderer multiplies them in, and treats missing ones as zero).
	mm.use_colors = true
	mm.mesh = mesh
	mm.instance_count = points.size()
	for i in points.size():
		var s := rng.randf_range(0.88, 1.08)
		var xf := Transform3D(Basis(Vector3.UP, rng.randf() * TAU).scaled(Vector3.ONE * s), points[i]["pos"] + Vector3(0, 0.15, 0))
		mm.set_instance_transform(i, xf)
		mm.set_instance_color(i, Color.WHITE)
		var cl: Color = CLOTHES[rng.randi() % CLOTHES.size()]
		mm.set_instance_custom_data(i, Color(cl.r, cl.g, cl.b, rng.randf()))
	var mmi := MultiMeshInstance3D.new()
	mmi.multimesh = mm
	var mat := ShaderMaterial.new()
	mat.shader = preload("res://world/crowd.gdshader")
	mmi.material_override = mat
	mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return mmi


## Low-poly person; vertex alpha marks clothes (1), skin (0), fixed colour (0.5).
static func _person_mesh(with_load: bool) -> ArrayMesh:
	var st := MeshKit.begin()
	var clothes := Color(1, 1, 1, 1)
	var skin := Color(1, 1, 1, 0)
	var dark := Color(0.12, 0.12, 0.14, 0.5)
	MeshKit.box(st, Vector3(-0.1, 0.4, 0), Vector3(0.14, 0.8, 0.16), dark)
	MeshKit.box(st, Vector3(0.1, 0.4, 0), Vector3(0.14, 0.8, 0.16), dark)
	MeshKit.prism(st, Vector3(0, 0.78, 0), 0.21, 0.72, clothes, 6)
	MeshKit.box(st, Vector3(-0.27, 1.1, 0), Vector3(0.1, 0.6, 0.12), skin)
	MeshKit.box(st, Vector3(0.27, 1.1, 0), Vector3(0.1, 0.6, 0.12), skin)
	MeshKit.prism(st, Vector3(0, 1.5, 0), 0.11, 0.24, skin, 6)
	if with_load:
		MeshKit.prism(st, Vector3(0, 1.76, 0), 0.34, 0.12, Color(0.75, 0.75, 0.78, 0.5), 8)
		MeshKit.box(st, Vector3(0.05, 1.93, 0), Vector3(0.36, 0.2, 0.3), Color(0.95, 0.55, 0.1, 0.5))
		MeshKit.box(st, Vector3(-0.12, 1.91, 0.08), Vector3(0.22, 0.16, 0.22), Color(0.85, 0.85, 0.95, 0.5))
	return st.commit()
