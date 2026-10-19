class_name TouchButton
extends Control
## Multi-touch on-screen control that presses an input action while any
## finger (or the mouse, via touch emulation) is held on it.

signal tapped

var action := ""
var caption := ""
var color := Color(1, 1, 1, 0.16)
var _touches := {}


func _init(action_name := "", text := "", tint := Color(1, 1, 1, 0.16)) -> void:
	action = action_name
	caption = text
	color = tint
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func is_held() -> bool:
	return not _touches.is_empty()


func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed and get_global_rect().has_point(touch.position):
			if _touches.is_empty():
				_set_pressed(true)
			_touches[touch.index] = true
			get_viewport().set_input_as_handled()
		elif not touch.pressed and _touches.has(touch.index):
			_touches.erase(touch.index)
			if _touches.is_empty():
				_set_pressed(false)


func _set_pressed(down: bool) -> void:
	if action != "":
		if down:
			Input.action_press(action)
		else:
			Input.action_release(action)
	if down:
		tapped.emit()
	queue_redraw()


func _exit_tree() -> void:
	if not _touches.is_empty() and action != "":
		Input.action_release(action)
	_touches.clear()


func _draw() -> void:
	var box := StyleBoxFlat.new()
	box.bg_color = color.lightened(0.3) if is_held() else color
	box.set_corner_radius_all(int(minf(size.x, size.y) * 0.25))
	box.border_color = Color(1, 1, 1, 0.35)
	box.set_border_width_all(2)
	draw_style_box(box, Rect2(Vector2.ZERO, size))
	if caption != "":
		var font := get_theme_default_font()
		var fs := int(clampf(size.y * 0.32, 16, 40))
		var text_size := font.get_string_size(caption, HORIZONTAL_ALIGNMENT_CENTER, -1, fs)
		draw_string(font, Vector2((size.x - text_size.x) * 0.5, (size.y + text_size.y * 0.6) * 0.5), caption,
			HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color(1, 1, 1, 0.9))
