class_name BusVisual
extends Node3D
## Original procedural danfo body: flat front, yellow paint with two black
## stripes, window band, a right-side sliding door and seated occupants seen
## through the windows. No manufacturer shapes, badges or real plates.

const GROUND_Y := -0.51
const FLOOR_Y := -0.18
const WAIST_Y := 0.62
const ROOF_Y := 1.44
const GLASS := Color(0.11, 0.15, 0.18)
const TRIM := Color(0.13, 0.13, 0.13)
const SKIN_TONES := [Color(0.36, 0.22, 0.14), Color(0.27, 0.16, 0.1), Color(0.45, 0.29, 0.19), Color(0.22, 0.13, 0.08)]
const CLOTHES := [
	Color(0.85, 0.2, 0.15), Color(0.1, 0.45, 0.25), Color(0.95, 0.95, 0.92), Color(0.2, 0.3, 0.7),
	Color(0.9, 0.6, 0.1), Color(0.55, 0.1, 0.45), Color(0.12, 0.12, 0.12), Color(0.0, 0.55, 0.6),
]

var length := 4.57
var width := 1.84
var body: MeshInstance3D
var door: MeshInstance3D
var wheels: Array[MeshInstance3D] = []
var bodies_mm: MultiMeshInstance3D
var heads_mm: MultiMeshInstance3D
var seat_anchors: Array[Vector3] = []
var door_open := false
## 0 = fresh coat, 1 = a hard-worked, much-repaired bus.
var wear := 0.3
var look_seed := 0
var _door_tween: Tween
var _rng := RandomNumberGenerator.new()


func build(model_id: String, paint_id: String, slogan: String, wear_level := 0.3, seed_value := 0) -> void:
	var dims: Dictionary = Content.BUS_MODELS[model_id]
	length = float(dims["length"])
	width = float(dims["width"])
	wear = wear_level
	look_seed = seed_value
	var paint: Dictionary = Content.PAINTS.get(paint_id, Content.PAINTS["lagos_yellow"])
	_build_body(paint)
	_build_door(paint)
	_build_wheels()
	_build_occupants(int(dims["seats"]))
	_build_labels(slogan)
	var shadow := MeshKit.blob_shadow(width + 0.9, length + 1.0)
	shadow.position = Vector3(0, GROUND_Y + 0.03, 0)
	add_child(shadow)


## Static wheels for parked buses and menu previews.
func park_wheels() -> void:
	var axles := [Vector3(-0.78, -0.17, -1.23), Vector3(0.78, -0.17, -1.23), Vector3(-0.78, -0.17, 1.23), Vector3(0.78, -0.17, 1.23)]
	for i in wheels.size():
		wheels[i].position = axles[i]
		wheels[i].rotation = Vector3(0, 0, PI * 0.5)


func repaint(paint_id: String) -> void:
	var paint: Dictionary = Content.PAINTS.get(paint_id, Content.PAINTS["lagos_yellow"])
	body.queue_free()
	door.queue_free()
	_build_body(paint)
	_build_door(paint)


func _build_body(paint: Dictionary) -> void:
	var yellow: Color = paint["body"]
	var stripe: Color = paint["stripe"]
	var hl := length * 0.5
	var hw := width * 0.5
	var st := MeshKit.begin()
	var lower_h := WAIST_Y - FLOOR_Y
	MeshKit.box(st, Vector3(0, FLOOR_Y + lower_h * 0.5, 0), Vector3(width, lower_h, length), yellow)
	MeshKit.box(st, Vector3(0, (WAIST_Y + 1.22) * 0.5, 0), Vector3(width - 0.04, 1.22 - WAIST_Y, length - 0.06), GLASS)
	MeshKit.box(st, Vector3(0, (1.22 + ROOF_Y) * 0.5, 0), Vector3(width - 0.02, ROOF_Y - 1.22, length - 0.04), yellow.lightened(0.05))
	# Window pillars, both sides, plus front and rear corners.
	for z in [-hl + 0.12, -1.25, 0.2, 1.0, 1.75, hl - 0.12]:
		for side: float in [-1.0, 1.0]:
			if side > 0.0 and z > -1.0 and z < 0.3:
				continue # sliding door opening on the right
			MeshKit.box(st, Vector3(side * (hw - 0.01), 0.92, z), Vector3(0.04, 0.6, 0.14), yellow)
	for side: float in [-1.0, 1.0]:
		MeshKit.box(st, Vector3(side * (hw - 0.08), 0.92, -hl + 0.02), Vector3(0.16, 0.6, 0.05), yellow)
		MeshKit.box(st, Vector3(side * (hw - 0.08), 0.92, hl - 0.02), Vector3(0.16, 0.6, 0.05), yellow)
	MeshKit.box(st, Vector3(0, 0.92, hl - 0.02), Vector3(0.1, 0.6, 0.05), yellow)
	# Two black stripes wrapping the body.
	for y: float in [0.5, 0.2]:
		MeshKit.box(st, Vector3(0, y, 0), Vector3(width + 0.014, 0.075, length + 0.014), stripe)
	# Front: plain horizontal grille, lamps, bumper. Rear: lamps, bumper.
	MeshKit.box(st, Vector3(0, 0.32, -hl - 0.01), Vector3(0.9, 0.16, 0.03), TRIM)
	for side: float in [-1.0, 1.0]:
		MeshKit.box(st, Vector3(side * 0.64, 0.33, -hl - 0.012), Vector3(0.24, 0.16, 0.03), Color(0.98, 0.95, 0.82))
		MeshKit.box(st, Vector3(side * 0.82, 0.12, -hl - 0.012), Vector3(0.12, 0.07, 0.03), Color(1.0, 0.55, 0.05))
		MeshKit.box(st, Vector3(side * 0.78, 0.32, hl + 0.012), Vector3(0.14, 0.26, 0.03), Color(0.75, 0.05, 0.04))
		# Mirror on a short arm.
		MeshKit.box(st, Vector3(side * (hw + 0.12), 0.78, -hl + 0.25), Vector3(0.24, 0.03, 0.03), TRIM)
		MeshKit.box(st, Vector3(side * (hw + 0.24), 0.82, -hl + 0.25), Vector3(0.05, 0.2, 0.12), TRIM)
	for z in [-hl - 0.05, hl + 0.05]:
		MeshKit.box(st, Vector3(0, -0.1, z), Vector3(width - 0.04, 0.16, 0.12), Color(0.18, 0.18, 0.17))
	# Plates (blank: no real plate format is copied).
	MeshKit.box(st, Vector3(0, 0.05, -hl - 0.12), Vector3(0.5, 0.12, 0.02), Color(0.92, 0.92, 0.9))
	MeshKit.box(st, Vector3(0, 0.05, hl + 0.12), Vector3(0.5, 0.12, 0.02), Color(0.92, 0.92, 0.9))
	# Dark wheel wells.
	for z: float in [-1.23, 1.23]:
		for side: float in [-1.0, 1.0]:
			MeshKit.box(st, Vector3(side * (hw - 0.005), -0.02, z), Vector3(0.02, 0.32, 0.86), Color(0.05, 0.05, 0.05))
	_add_wear(st, yellow)
	body = MeshInstance3D.new()
	st.index()
	body.mesh = st.commit()
	body.material_override = MeshKit.weathered(0.12 + wear * 0.3, 0.1 + wear * 0.2, 0.15 + wear * 0.3, true)
	add_child(body)


## Hard use shows: rust and primer patches, panels from other buses, a
## sun-faded roof, a bent bumper, sometimes a roof rack.
func _add_wear(st: SurfaceTool, yellow: Color) -> void:
	_rng.seed = look_seed
	var hl := length * 0.5
	var hw := width * 0.5
	var patches := int(round(wear * 9.0))
	for i in patches:
		var side := -1.0 if _rng.randf() < 0.5 else 1.0
		var z := _rng.randf_range(-hl + 0.3, hl - 0.3)
		var y := _rng.randf_range(FLOOR_Y + 0.08, WAIST_Y - 0.05)
		var tone: Color
		var roll := _rng.randf()
		if roll < 0.4:
			tone = Color(0.45, 0.24, 0.13).lerp(Color(0.6, 0.35, 0.18), _rng.randf())
		elif roll < 0.7:
			tone = Color(0.55, 0.56, 0.53)
		else:
			tone = yellow.lerp(Color(0.95, 0.88, 0.55), _rng.randf_range(0.3, 0.7))
		MeshKit.box(st, Vector3(side * (hw + 0.006), y, z), Vector3(0.012, _rng.randf_range(0.08, 0.3), _rng.randf_range(0.15, 0.7)), tone)
	if wear > 0.45:
		# Rusty sills along the bottom edge.
		for side: float in [-1.0, 1.0]:
			MeshKit.box(st, Vector3(side * (hw + 0.004), FLOOR_Y + 0.05, 0), Vector3(0.01, 0.1, length * _rng.randf_range(0.5, 0.95)), Color(0.4, 0.22, 0.12))
	if wear > 0.6:
		# A replacement panel from another bus that was never repainted.
		var side := -1.0
		MeshKit.box(st, Vector3(side * (hw + 0.008), (FLOOR_Y + WAIST_Y) * 0.5, _rng.randf_range(0.4, 1.5)), Vector3(0.012, WAIST_Y - FLOOR_Y - 0.1, 0.9),
			[Color(0.55, 0.56, 0.53), Color(0.9, 0.9, 0.86), Color(0.85, 0.62, 0.1)][_rng.randi() % 3])
		# Bent rear bumper.
		MeshKit.box(st, Vector3(0.2, -0.16, hl + 0.09), Vector3(width * 0.6, 0.14, 0.1), Color(0.2, 0.2, 0.19), Basis(Vector3.FORWARD, 0.08))
	# Sun-faded roof.
	MeshKit.box(st, Vector3(0, ROOF_Y + 0.004, 0), Vector3(width - 0.1, 0.008, length - 0.15), yellow.lerp(Color(0.92, 0.88, 0.7), 0.3 + wear * 0.4))
	if _rng.randf() < 0.3 + wear * 0.3:
		# Roof rack.
		for x: float in [-0.75, 0.75]:
			MeshKit.box(st, Vector3(x, ROOF_Y + 0.12, 0.2), Vector3(0.05, 0.05, length * 0.6), Color(0.15, 0.15, 0.15))
		for z: float in [-0.8, 0.0, 0.8, 1.4]:
			MeshKit.box(st, Vector3(0, ROOF_Y + 0.12, z), Vector3(1.55, 0.05, 0.05), Color(0.15, 0.15, 0.15))
			MeshKit.box(st, Vector3(0, ROOF_Y + 0.05, z), Vector3(0.05, 0.1, 0.05), Color(0.15, 0.15, 0.15))


func _build_door(paint: Dictionary) -> void:
	var yellow: Color = paint["body"]
	var st := MeshKit.begin()
	var lower_h := WAIST_Y - FLOOR_Y
	MeshKit.box(st, Vector3(0, FLOOR_Y + lower_h * 0.5, 0), Vector3(0.05, lower_h, 1.2), yellow)
	MeshKit.box(st, Vector3(0, 0.92, 0), Vector3(0.045, 0.6, 1.2), GLASS)
	MeshKit.box(st, Vector3(0.002, 0.92, 0.57), Vector3(0.05, 0.6, 0.06), yellow)
	MeshKit.box(st, Vector3(0.002, 0.92, -0.57), Vector3(0.05, 0.6, 0.06), yellow)
	for y: float in [0.5, 0.2]:
		MeshKit.box(st, Vector3(0, y, 0), Vector3(0.06, 0.075, 1.2), paint["stripe"])
	if wear > 0.5:
		MeshKit.box(st, Vector3(0.03, 0.05, 0.3), Vector3(0.012, 0.2, 0.4), Color(0.45, 0.24, 0.13))
	door = MeshInstance3D.new()
	st.index()
	door.mesh = st.commit()
	door.material_override = MeshKit.weathered(0.12 + wear * 0.3, 0.1 + wear * 0.2, 0.15 + wear * 0.3, true)
	door.position = _door_closed_position()
	add_child(door)


func _door_closed_position() -> Vector3:
	return Vector3(width * 0.5 + 0.02, 0, -0.35)


func set_door_open(open: bool) -> void:
	if open == door_open:
		return
	door_open = open
	if _door_tween:
		_door_tween.kill()
	var target := _door_closed_position()
	if open:
		target += Vector3(0.07, 0, 1.15)
	_door_tween = create_tween()
	_door_tween.tween_property(door, "position", target, 0.45).set_trans(Tween.TRANS_SINE)


func _build_wheels() -> void:
	var tyre := CylinderMesh.new()
	tyre.top_radius = 0.34
	tyre.bottom_radius = 0.34
	tyre.height = 0.22
	tyre.radial_segments = 12
	tyre.rings = 1
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.07, 0.07, 0.07)
	mat.roughness = 0.9
	for i in 4:
		var w := MeshInstance3D.new()
		w.mesh = tyre
		w.material_override = mat
		add_child(w)
		wheels.append(w)


func update_wheels(bus: Bus, delta: float) -> void:
	for i in wheels.size():
		var mount: Vector3 = bus.wheel_mounts[i]
		var drop := bus.suspension_travel - bus.wheel_compression[i]
		var w := wheels[i]
		w.position = mount - Vector3(0, drop, 0)
		var yaw := -bus.steer_angle if i < 2 else 0.0
		w.rotation = Vector3(0, yaw, 0)
		w.rotate_object_local(Vector3.FORWARD, PI * 0.5)


func _build_occupants(seats: int) -> void:
	# Driver (left-hand drive) and two front passengers, then benches of four.
	seat_anchors.clear()
	var front_z := -1.62
	seat_anchors.append(Vector3(-0.45, 0.48, front_z)) # driver
	seat_anchors.append(Vector3(0.62, 0.48, -0.55)) # conductor, by the door
	seat_anchors.append(Vector3(0.12, 0.48, front_z))
	seat_anchors.append(Vector3(0.5, 0.48, front_z))
	for row_z: float in [0.15, 0.9, 1.65]:
		for x: float in [-0.66, -0.22, 0.22, 0.66]:
			if seat_anchors.size() < seats + 2:
				seat_anchors.append(Vector3(x, 0.48, row_z))
	var torso := CapsuleMesh.new()
	torso.radius = 0.17
	torso.height = 0.62
	torso.radial_segments = 8
	torso.rings = 2
	var head := SphereMesh.new()
	head.radius = 0.11
	head.height = 0.22
	head.radial_segments = 8
	head.rings = 4
	bodies_mm = _occupant_multimesh(torso, seat_anchors.size())
	heads_mm = _occupant_multimesh(head, seat_anchors.size())
	for i in seat_anchors.size():
		set_seat_occupied(i, i < 2, i)


func _occupant_multimesh(mesh: Mesh, count: int) -> MultiMeshInstance3D:
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.use_colors = true
	mm.mesh = mesh
	mm.instance_count = count
	var mmi := MultiMeshInstance3D.new()
	mmi.multimesh = mm
	mmi.material_override = MeshKit.material(0.9)
	mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(mmi)
	return mmi


## Shows or hides a seated figure. Index 0 is the driver, 1 the conductor,
## passenger seat n is index n + 2.
func set_seat_occupied(index: int, occupied: bool, look_seed: int) -> void:
	if index < 0 or index >= seat_anchors.size():
		return
	var anchor := seat_anchors[index]
	var s := 1.0 if occupied else 0.0
	var torso_xf := Transform3D(Basis().scaled(Vector3.ONE * maxf(s, 0.0001)), anchor)
	var head_xf := Transform3D(Basis().scaled(Vector3.ONE * maxf(s, 0.0001)), anchor + Vector3(0, 0.42, 0))
	bodies_mm.multimesh.set_instance_transform(index, torso_xf)
	heads_mm.multimesh.set_instance_transform(index, head_xf)
	bodies_mm.multimesh.set_instance_color(index, CLOTHES[look_seed % CLOTHES.size()])
	heads_mm.multimesh.set_instance_color(index, SKIN_TONES[look_seed % SKIN_TONES.size()])


func set_passenger_seat(seat: int, occupied: bool, look_seed: int) -> void:
	set_seat_occupied(seat + 2, occupied, look_seed)


func _build_labels(slogan: String) -> void:
	if slogan == "":
		return
	var label := Label3D.new()
	label.text = slogan
	label.font_size = 44
	label.pixel_size = 0.0035
	label.modulate = Color(0.06, 0.06, 0.06)
	label.outline_size = 0
	label.position = Vector3(0, 1.31, length * 0.5 + 0.03)
	label.double_sided = false
	add_child(label)
	var front := Label3D.new()
	front.text = slogan
	front.font_size = 40
	front.pixel_size = 0.0032
	front.modulate = Color(0.06, 0.06, 0.06)
	front.position = Vector3(0, 1.31, -length * 0.5 - 0.03)
	front.rotation = Vector3(0, PI, 0)
	front.double_sided = false
	add_child(front)
