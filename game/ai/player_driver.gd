class_name PlayerDriver
extends RefCounted
## Reads the shared input actions (keyboard, gamepad or touch buttons), or the
## accelerometer when tilt steering is selected in Settings.

var scheme := "buttons"
var sensitivity := 1.0


func _init() -> void:
	scheme = str(GameState.pref("control_scheme"))
	sensitivity = float(GameState.pref("steer_sensitivity"))


func drive_input(_bus: Bus) -> Dictionary:
	var steer := Input.get_action_strength("steer_right") - Input.get_action_strength("steer_left")
	if scheme == "tilt" and absf(steer) < 0.01:
		# Landscape tilt: the accelerometer's y axis reads left/right lean.
		steer = clampf(Input.get_accelerometer().y / 4.5, -1.0, 1.0)
	return {
		"throttle": Input.get_action_strength("accelerate"),
		"brake": Input.get_action_strength("brake"),
		"steer": clampf(steer * sensitivity, -1.0, 1.0),
	}
