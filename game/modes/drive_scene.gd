class_name DriveScene
extends Node3D
## Shared base for Work and Race: builds the district, the player's bus,
## camera and HUD, counts active play time for ad pacing, and handles pause.

signal finished(summary: Dictionary)
signal exited
signal restart_requested

var layout: DistrictLayout
var city: CityBuilder
var hud: Hud
var camera: ChaseCamera
var player: Bus
var event_id := ""
## Smoke tests drive the player's bus with the AI instead of input.
var autopilot := false
var elapsed := 0.0
var _idle := 0.0
var _ended := false
var _pause_layer: CanvasLayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	layout = DistrictLayout.new()
	layout.generate()
	EnvironmentBuilder.add_to(self)
	city = CityBuilder.new()
	city.name = "City"
	add_child(city)
	city.build(layout, city_options())
	add_child(Ambience.new())
	hud = Hud.new()
	add_child(hud)
	hud.pause_pressed.connect(open_pause)
	setup_mode()


## Override in each mode.
func setup_mode() -> void:
	pass


## Override: what the city should include for this mode.
func city_options() -> Dictionary:
	return {}


## Override: per-tick mode logic.
func mode_physics(_delta: float) -> void:
	pass


## Override: true while required service animations run (counts as active).
func is_servicing() -> bool:
	return false


## Override: label for the pause menu's leave button.
func leave_label() -> String:
	return "Quit to menu"


## Override: called when the player leaves from the pause menu.
func leave_from_pause() -> void:
	exited.emit()


func spawn_player(pos: Vector3, facing: Basis) -> Bus:
	var b := GameState.bus()
	player = Bus.create(b["model"], b["paint"], "", 0.45, 11)
	player.name = "PlayerBus"
	add_child(player)
	player.place_at(pos, facing)
	player.bounds = layout.half_extent() + DistrictLayout.ROAD_WIDTH
	player.enable_audio(b["horn"], true)
	player.driver = PlayerDriver.new()
	camera = ChaseCamera.new()
	camera.target = player
	camera.reduced_motion = bool(GameState.pref("reduced_motion"))
	add_child(camera)
	camera.current = true
	return player


func _physics_process(delta: float) -> void:
	if _ended or player == null:
		return
	elapsed += delta
	hud.set_speed(player.kmh())
	if Input.is_action_just_pressed("reset_bus"):
		player.recover()
	if Input.is_action_just_pressed("horn"):
		player.play_horn()
	if Input.is_action_just_pressed("pause"):
		open_pause()
	var input_active := player.throttle > 0.0 or player.brake > 0.0 or absf(player.steer_input) > 0.0
	if input_active or player.kmh() > 2.0 or is_servicing() or autopilot:
		_idle = 0.0
	else:
		_idle += delta
	if _idle < 15.0:
		GameState.record_active_time(delta)
	mode_physics(delta)


func finish(summary: Dictionary) -> void:
	if _ended:
		return
	_ended = true
	summary["event_id"] = event_id
	summary["distance_m"] = player.distance_travelled
	finished.emit(summary)


func open_pause() -> void:
	if _ended or _pause_layer != null:
		return
	get_tree().paused = true
	_pause_layer = CanvasLayer.new()
	_pause_layer.layer = 50
	_pause_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_pause_layer)
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.6)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_pause_layer.add_child(shade)
	var box := UiKit.centered_column(_pause_layer)
	UiKit.title(box, "Paused")
	UiKit.big_button(box, "Resume", close_pause)
	UiKit.big_button(box, "Restart", func():
		close_pause()
		restart_requested.emit())
	UiKit.big_button(box, leave_label(), func():
		close_pause()
		leave_from_pause())


func close_pause() -> void:
	if _pause_layer:
		_pause_layer.queue_free()
		_pause_layer = null
	get_tree().paused = false


func _notification(what: int) -> void:
	# Leaving the app mid-drive pauses instead of letting the bus run on.
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_APPLICATION_PAUSED:
		if not autopilot and is_inside_tree():
			open_pause()
