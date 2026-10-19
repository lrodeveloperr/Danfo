extends Node
## Screen flow: menus, the two driving modes and results. Also owns the input
## map so keyboard, gamepad and touch all drive the same actions.
##
## Ad placement follows PRODUCT_SPEC.md: an automatic interstitial can only
## appear when leaving the results of a completed qualifying event (after the
## result is saved), never during driving, menus, My Bus, pause or launch.

var root: Node
var current: Node
var last_event := {}
## Automated tests drive the player's bus with the AI.
var test_autopilot := false
var _leaving_results := false


func _ready() -> void:
	_setup_input()
	get_tree().quit_on_go_back = false


func boot(main_root: Node) -> void:
	root = main_root
	apply_audio()
	go_main_menu()


func apply_audio() -> void:
	var volume := maxf(float(GameState.pref("volume")), 0.0001)
	AudioServer.set_bus_volume_db(0, linear_to_db(volume))


func _show(node: Node) -> void:
	get_tree().paused = false
	if current != null and is_instance_valid(current):
		current.queue_free()
	current = node
	root.add_child(node)


func go_main_menu() -> void:
	_show(MainMenu.new())


func go_work_select() -> void:
	_show(WorkSelect.new())


func go_race_select() -> void:
	_show(RaceSelect.new())


func go_my_bus() -> void:
	_show(MyBusScreen.new())


func go_settings() -> void:
	_show(SettingsScreen.new())


func start_work(route_id := "garage_loop") -> void:
	last_event = {"mode": "work", "route_id": route_id}
	var mode := WorkMode.new()
	mode.route_id = route_id
	_hook(mode)
	_show(mode)


func start_race(course_id := "ring_road", difficulty := "normal") -> void:
	last_event = {"mode": "race", "course_id": course_id, "difficulty": difficulty}
	var mode := RaceMode.new()
	mode.course_id = course_id
	mode.difficulty = difficulty
	_hook(mode)
	_show(mode)


func _hook(mode: DriveScene) -> void:
	mode.autopilot = test_autopilot
	mode.finished.connect(_on_event_finished)
	mode.exited.connect(func(): go_main_menu.call_deferred())
	mode.restart_requested.connect(func(): replay.call_deferred())


## Settles (and saves) the event before the results screen exists.
func _on_event_finished(summary: Dictionary) -> void:
	var settlement := GameState.settle_event(summary)
	var screen := ResultsScreen.new()
	screen.summary = summary
	screen.settlement = settlement
	_show.call_deferred(screen)


func replay() -> void:
	if last_event.get("mode") == "work":
		start_work(last_event["route_id"])
	elif last_event.get("mode") == "race":
		start_race(last_event["course_id"], last_event["difficulty"])
	else:
		go_main_menu()


func next_event() -> void:
	if last_event.get("mode") == "race":
		var ids := Content.COURSES.keys()
		var next_id: String = ids[(ids.find(last_event["course_id"]) + 1) % ids.size()]
		start_race(next_id, last_event["difficulty"])
	else:
		replay()


## Leaving results with Next or Replay: show an eligible interstitial first.
func after_results(action: Callable, screen: ResultsScreen) -> void:
	if _leaving_results:
		return
	_leaving_results = true
	var qualifying: bool = screen.summary.get("qualifying", false)
	if qualifying and not screen.rewarded_shown and GameState.interstitial_eligible() and Ads.interstitial_ready():
		Ads.show_interstitial()
		await Ads.interstitial_closed
		GameState.record_fullscreen_closed()
	_leaving_results = false
	action.call()


func _notification(what: int) -> void:
	if what != NOTIFICATION_WM_GO_BACK_REQUEST or current == null:
		return
	if current is DriveScene:
		(current as DriveScene).open_pause()
	elif current is MainMenu:
		get_tree().quit()
	elif not current is ResultsScreen:
		go_main_menu()


func _setup_input() -> void:
	var keys := {
		"accelerate": [KEY_W, KEY_UP],
		"brake": [KEY_S, KEY_DOWN],
		"steer_left": [KEY_A, KEY_LEFT],
		"steer_right": [KEY_D, KEY_RIGHT],
		"horn": [KEY_H, KEY_SPACE],
		"reset_bus": [KEY_R],
		"pause": [KEY_ESCAPE, KEY_P],
	}
	for action in keys:
		if not InputMap.has_action(action):
			InputMap.add_action(action, 0.2)
		for code in keys[action]:
			var ev := InputEventKey.new()
			ev.physical_keycode = code
			InputMap.action_add_event(action, ev)
	var pads := {
		"accelerate": [JOY_AXIS_TRIGGER_RIGHT, 1.0],
		"brake": [JOY_AXIS_TRIGGER_LEFT, 1.0],
		"steer_left": [JOY_AXIS_LEFT_X, -1.0],
		"steer_right": [JOY_AXIS_LEFT_X, 1.0],
	}
	for action in pads:
		var motion := InputEventJoypadMotion.new()
		motion.axis = pads[action][0]
		motion.axis_value = pads[action][1]
		InputMap.action_add_event(action, motion)
