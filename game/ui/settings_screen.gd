class_name SettingsScreen
extends Control
## Controls, sound, subtitles and camera comfort.


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var root := UiKit.screen(self)
	var box := UiKit.centered_column(root, 14)
	UiKit.title(box, "Settings")
	var card := UiKit.card(box, Vector2(640, 0))

	UiKit.label(card, "Steering", 22, UiKit.YELLOW)
	var scheme_row := UiKit.row(card)
	for scheme in [["buttons", "Buttons"], ["tilt", "Tilt"]]:
		UiKit.big_button(scheme_row, scheme[1], func():
			GameState.set_pref("control_scheme", scheme[0])
			App.go_settings(), GameState.pref("control_scheme") == scheme[0], Vector2(200, 56))
	_slider(card, "Steering sensitivity", "steer_sensitivity", 0.5, 1.5)
	_slider(card, "Volume", "volume", 0.0, 1.0)
	_toggle(card, "Subtitles", "subtitles")
	_toggle(card, "Reduced camera motion", "reduced_motion")
	UiKit.big_button(box, "Back", App.go_main_menu)


func _slider(parent: Node, text: String, key: String, lo: float, hi: float) -> void:
	UiKit.label(parent, text, 20)
	var s := HSlider.new()
	s.min_value = lo
	s.max_value = hi
	s.step = 0.05
	s.value = float(GameState.pref(key))
	s.custom_minimum_size = Vector2(560, 40)
	s.drag_ended.connect(func(_changed):
		GameState.set_pref(key, s.value)
		App.apply_audio())
	parent.add_child(s)


func _toggle(parent: Node, text: String, key: String) -> void:
	var c := CheckButton.new()
	c.text = text
	c.button_pressed = bool(GameState.pref(key))
	c.add_theme_font_size_override("font_size", 22)
	c.toggled.connect(func(on): GameState.set_pref(key, on))
	parent.add_child(c)
