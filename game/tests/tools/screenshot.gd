extends SceneTree
## Renders screenshots for visual checks:
## godot --path . --rendering-driver opengl3 -s tests/tools/screenshot.gd -- race|work|menu out_dir [frames...]

var _scene: Node
var _out := "user://shots"
var _frames := 0
var _shots := [90, 400, 900]


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var which: String = args[0] if args.size() > 0 else "race"
	if args.size() > 1:
		_out = args[1]
	if args.size() > 2:
		_shots = []
		for a in args.slice(2):
			_shots.append(int(a))
	DirAccess.make_dir_recursive_absolute(_out)
	var scripts := {"race": "res://modes/race_mode.gd", "work": "res://modes/work_mode.gd"}
	if scripts.has(which):
		_scene = load(scripts[which]).new()
		_scene.autopilot = true
		root.add_child(_scene)
	else:
		var app := root.get_node("App")
		app.boot(root)
		app.call("go_" + which)


func _process(_delta: float) -> bool:
	_frames += 1
	if _frames in _shots:
		var img := root.get_texture().get_image()
		img.save_png("%s/shot_%04d.png" % [_out, _frames])
		print("saved shot ", _frames)
	return _frames > _shots[-1]
