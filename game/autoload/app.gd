extends Node
## Screen flow: menus, the two driving modes and results. Also owns the input
## map so keyboard, gamepad and touch all drive the same actions.

var root: Node
var current: Node


func _ready() -> void:
	_setup_input()


func boot(main_root: Node) -> void:
	root = main_root


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
