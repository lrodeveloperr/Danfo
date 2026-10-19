class_name Pedestrian
extends Node3D
## A simple walking figure for waiting, boarding and alighting passengers and
## roadside people. Keeps one look (clothes and skin) for its whole journey.

signal arrived

static var _torso: CapsuleMesh
static var _head: SphereMesh
static var _materials := {}

var look_seed := 0
var speed := 1.5
## Hawkers carry a tray or basin of goods on their heads.
var carries_load := false
var _patrol: Array[Vector3] = []
var _patrol_i := 0
var _target: Variant = null
var _phase := 0.0
var _body: MeshInstance3D


static func create(look: int) -> Pedestrian:
	var p := Pedestrian.new()
	p.look_seed = look
	return p


func _ready() -> void:
	if _torso == null:
		_torso = CapsuleMesh.new()
		_torso.radius = 0.2
		_torso.height = 1.25
		_torso.radial_segments = 8
		_torso.rings = 2
		_head = SphereMesh.new()
		_head.radius = 0.13
		_head.height = 0.26
		_head.radial_segments = 8
		_head.rings = 4
	_body = MeshInstance3D.new()
	_body.mesh = _torso
	_body.position = Vector3(0, 0.78, 0)
	_body.material_override = _material(BusVisual.CLOTHES[look_seed % BusVisual.CLOTHES.size()])
	_body.visibility_range_end = 90.0
	add_child(_body)
	var head := MeshInstance3D.new()
	head.mesh = _head
	head.position = Vector3(0, 0.62 + 0.15, 0)
	head.material_override = _material(BusVisual.SKIN_TONES[look_seed % BusVisual.SKIN_TONES.size()])
	head.visibility_range_end = 90.0
	_body.add_child(head)
	if carries_load:
		var basin := MeshInstance3D.new()
		var cyl := CylinderMesh.new()
		cyl.top_radius = 0.36
		cyl.bottom_radius = 0.3
		cyl.height = 0.14
		cyl.radial_segments = 10
		cyl.rings = 1
		basin.mesh = cyl
		basin.material_override = _material(Color(0.75, 0.75, 0.78))
		basin.position = Vector3(0, 0.95, 0)
		_body.add_child(basin)
		var goods := MeshInstance3D.new()
		var box := BoxMesh.new()
		box.size = Vector3(0.4, 0.2, 0.32)
		goods.mesh = box
		goods.material_override = _material([Color(0.95, 0.55, 0.1), Color(0.85, 0.85, 0.95), Color(0.2, 0.6, 0.25)][look_seed % 3])
		goods.position = Vector3(0, 1.12, 0)
		_body.add_child(goods)
	_phase = float(look_seed % 7)


static func _material(color: Color) -> StandardMaterial3D:
	var key := color.to_html()
	if not _materials.has(key):
		var m := StandardMaterial3D.new()
		m.albedo_color = color
		m.roughness = 0.9
		_materials[key] = m
	return _materials[key]


## Walks back and forth between two points until told otherwise.
func patrol(a: Vector3, b: Vector3) -> void:
	_patrol = [a, b]
	_patrol_i = 0
	walk_to(a, 1.1)
	arrived.connect(func():
		if not _patrol.is_empty():
			_patrol_i = 1 - _patrol_i
			walk_to(_patrol[_patrol_i], 1.1))


func walk_to(target: Vector3, walk_speed := 1.6) -> void:
	_target = target
	speed = walk_speed


func is_walking() -> bool:
	return _target != null


func _process(delta: float) -> void:
	_phase += delta
	if _target == null:
		_body.position.y = 0.78 + sin(_phase * 1.3) * 0.01
		return
	var to: Vector3 = (_target as Vector3) - global_position
	to.y = 0.0
	var step := speed * delta
	if to.length() <= step:
		global_position = Vector3(_target.x, global_position.y, _target.z)
		_target = null
		arrived.emit()
		return
	global_position += to.normalized() * step
	look_at(global_position + to, Vector3.UP)
	_body.position.y = 0.78 + absf(sin(_phase * 9.0)) * 0.05
