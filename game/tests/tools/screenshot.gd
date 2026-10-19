extends SceneTree
## Renders screenshots for visual checks:
## godot --path . --rendering-driver opengl3 -s tests/tools/screenshot.gd -- race|work|menu out_dir [frames...]

var _scene: Node
var _out := "user://shots"
var _frames := 0
var _shots := [90, 400, 900]
var _open := ""
var _tour: Array = []


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
	if which == "tour":
		# Visit several stops in one run: teleport, settle, capture.
		_scene = load(scripts["work"]).new()
		_scene.rng_seed = 3
		root.add_child(_scene)
		_tour = ["Garage", "Market Junction", "Under Bridge", "Church Gate", "Filling Station", "Mechanic Village"]
		_shots = []
		for i in _tour.size():
			_shots.append(40 + i * 45)
		return
	if scripts.has(which):
		_scene = load(scripts[which]).new()
		_scene.autopilot = true
		root.add_child(_scene)
	else:
		# Boot the real main scene, then open the requested screen.
		change_scene_to_file.call_deferred("res://main.tscn")
		_open = "go_" + which


func _process(_delta: float) -> bool:
	_frames += 1
	if not _tour.is_empty() and (_frames - 15) % 45 == 0 and (_frames - 15) / 45 < _tour.size():
		var stop: Dictionary = _scene.layout.stops_by_name[_tour[(_frames - 15) / 45]]
		var side: Dictionary = stop["sides"][1]
		var dir: Vector3 = side["direction"]
		_scene.player.place_at(side["stop_point"] - dir * 16.0, Basis.looking_at(dir, Vector3.UP))
		_scene.camera.snap()
	if _frames == 5 and _open == "go_results":
		_show_sample_results()
	elif _frames == 5 and _open != "":
		root.get_node("App").call(_open)
	if _frames in _shots:
		var img := root.get_texture().get_image()
		img.save_png("%s/shot_%04d.png" % [_out, _frames])
		print("saved shot ", _frames)
	return _frames > _shots[-1]


## Settles a sample race into a throwaway save and shows its results screen.
func _show_sample_results() -> void:
	var gs := root.get_node("GameState")
	gs.store = load("res://core/save_store.gd").new("user://screenshot_sample.dat")
	gs.store.delete_all()
	gs.data = gs.default_data()
	var summary := {"event_id": "sample-race", "mode": "race", "course_id": "ring_road", "position": 2,
		"racers": 4, "finish_time": 101.3, "qualifying": true, "distance_m": 1850.0,
		"order": ["mama_kemi", "player", "ayo_late_brake", "chidi_corner"]}
	var screen: Control = load("res://ui/results_screen.gd").new()
	screen.summary = summary
	screen.settlement = gs.settle_event(summary)
	root.get_node("App")._show(screen)
	gs.store.delete_all()
