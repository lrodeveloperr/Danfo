class_name BusPreview
extends SubViewportContainer
## Slowly turning 3D preview of the player's bus for the menus.

var visual: BusVisual
var _pivot: Node3D


func _init(preview_size := Vector2i(560, 300)) -> void:
	stretch = true
	custom_minimum_size = Vector2(preview_size)
	var vp := SubViewport.new()
	vp.size = preview_size
	vp.transparent_bg = true
	vp.own_world_3d = true
	vp.msaa_3d = Viewport.MSAA_2X
	add_child(vp)
	var world := Node3D.new()
	vp.add_child(world)
	var env := Environment.new()
	env.background_mode = Environment.BG_CLEAR_COLOR
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.75, 0.75, 0.8)
	env.ambient_light_energy = 0.7
	var we := WorldEnvironment.new()
	we.environment = env
	world.add_child(we)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-40, 30, 0)
	sun.light_energy = 1.2
	world.add_child(sun)
	_pivot = Node3D.new()
	world.add_child(_pivot)
	var cam := Camera3D.new()
	var eye := Vector3(0, 1.6, 7.2)
	cam.transform = Transform3D(Basis.looking_at(Vector3(0, 0.4, 0) - eye, Vector3.UP), eye)
	cam.fov = 40.0
	cam.current = true
	world.add_child(cam)
	rebuild()


func rebuild() -> void:
	if visual:
		visual.queue_free()
	var b := GameState.bus()
	visual = BusVisual.new()
	_pivot.add_child(visual)
	visual.build(b["model"], b["paint"], "")
	var axles := [Vector3(-0.78, -0.17, -1.23), Vector3(0.78, -0.17, -1.23), Vector3(-0.78, -0.17, 1.23), Vector3(0.78, -0.17, 1.23)]
	for i in visual.wheels.size():
		visual.wheels[i].position = axles[i]
		visual.wheels[i].rotation = Vector3(0, 0, PI * 0.5)


func _process(delta: float) -> void:
	_pivot.rotation.y += delta * 0.35
