class_name Hud
extends CanvasLayer
## Driving HUD: speed, mode info, a centre banner, a guidance arrow and the
## touch controls (steer left/right, accelerate, brake, horn, pause).

signal pause_pressed

var speed_label: Label
var info_label: Label
var banner: Label
var toast: Label
var arrow: GuidanceArrow
var controls: Control
var _toast_time := 0.0


func _ready() -> void:
	layer = 10
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)

	speed_label = _label(root, 40, HORIZONTAL_ALIGNMENT_LEFT)
	speed_label.position = Vector2(28, 18)
	info_label = _label(root, 22, HORIZONTAL_ALIGNMENT_LEFT)
	info_label.position = Vector2(28, 74)

	banner = _label(root, 40, HORIZONTAL_ALIGNMENT_CENTER)
	_span(banner, 0.0, 1.0, 0.0, 130.0, 180.0)
	toast = _label(root, 28, HORIZONTAL_ALIGNMENT_CENTER)
	_span(toast, 0.0, 1.0, 0.0, 190.0, 236.0)
	toast.add_theme_color_override("font_color", Color(1.0, 0.86, 0.2))

	arrow = GuidanceArrow.new()
	_span(arrow, 0.5, 0.5, 0.0, 10.0, 100.0)
	arrow.offset_left = -45.0
	arrow.offset_right = 45.0
	arrow.visible = false
	root.add_child(arrow)

	controls = Control.new()
	controls.set_anchors_preset(Control.PRESET_FULL_RECT)
	controls.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(controls)
	_add_button("steer_left", "◀", Control.PRESET_BOTTOM_LEFT, Vector2(24, -24), Vector2(150, 150))
	_add_button("steer_right", "▶", Control.PRESET_BOTTOM_LEFT, Vector2(194, -24), Vector2(150, 150))
	_add_button("accelerate", "GO", Control.PRESET_BOTTOM_RIGHT, Vector2(-24, -24), Vector2(150, 190), Color(0.2, 0.9, 0.3, 0.22))
	_add_button("brake", "BRAKE", Control.PRESET_BOTTOM_RIGHT, Vector2(-194, -24), Vector2(140, 130), Color(0.95, 0.25, 0.2, 0.22))
	_add_button("horn", "HORN", Control.PRESET_BOTTOM_RIGHT, Vector2(-24, -234), Vector2(110, 70), Color(1.0, 0.85, 0.1, 0.2))
	var pause := _add_button("", "II", Control.PRESET_TOP_RIGHT, Vector2(-20, 20), Vector2(76, 64))
	pause.tapped.connect(func(): pause_pressed.emit())


## Anchors a control between horizontal anchors, at fixed pixel rows from the top.
static func _span(c: Control, left: float, right: float, top_anchor: float, top: float, bottom: float) -> void:
	c.anchor_left = left
	c.anchor_right = right
	c.anchor_top = top_anchor
	c.anchor_bottom = top_anchor
	c.offset_left = 0.0
	c.offset_right = 0.0
	c.offset_top = top
	c.offset_bottom = bottom


func _label(parent: Control, font_size: int, align: HorizontalAlignment) -> Label:
	var l := Label.new()
	l.add_theme_font_size_override("font_size", font_size)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	l.add_theme_constant_override("outline_size", 8)
	l.horizontal_alignment = align
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(l)
	return l


func _add_button(action: String, text: String, preset: int, offset: Vector2, button_size: Vector2, tint := Color(1, 1, 1, 0.16)) -> TouchButton:
	var b := TouchButton.new(action, text, tint)
	b.set_anchors_preset(preset)
	b.size = button_size
	var pos := offset
	if preset in [Control.PRESET_BOTTOM_RIGHT, Control.PRESET_TOP_RIGHT]:
		pos.x -= button_size.x
	if preset in [Control.PRESET_BOTTOM_LEFT, Control.PRESET_BOTTOM_RIGHT]:
		pos.y -= button_size.y
	b.position = pos
	controls.add_child(b)
	return b


func set_speed(kmh: float) -> void:
	speed_label.text = "%d km/h" % int(round(kmh))


func set_info(text: String) -> void:
	info_label.text = text


func set_banner(text: String) -> void:
	banner.text = text


func show_toast(text: String, seconds := 2.0) -> void:
	toast.text = text
	_toast_time = seconds


## Points the arrow at `world_target` relative to the bus heading.
func set_guidance(bus: Bus, world_target: Variant, distance_text := "") -> void:
	if world_target == null or bus == null:
		arrow.visible = false
		return
	arrow.visible = true
	var to := (world_target as Vector3) - bus.global_position
	to.y = 0.0
	var fwd := bus.forward_vector()
	fwd.y = 0.0
	arrow.angle = fwd.signed_angle_to(to, Vector3.DOWN) if to.length() > 0.5 else 0.0
	arrow.caption = distance_text
	arrow.queue_redraw()


func _process(delta: float) -> void:
	if _toast_time > 0.0:
		_toast_time -= delta
		if _toast_time <= 0.0:
			toast.text = ""


class GuidanceArrow extends Control:
	var angle := 0.0
	var caption := ""

	func _draw() -> void:
		var c := size * 0.5
		var r := minf(size.x, size.y) * 0.42
		draw_circle(c, r + 6.0, Color(0, 0, 0, 0.35))
		var pts := PackedVector2Array([Vector2(0, -r), Vector2(r * 0.6, r * 0.55), Vector2(0, r * 0.25), Vector2(-r * 0.6, r * 0.55)])
		var rotated := PackedVector2Array()
		for p in pts:
			rotated.append(c + p.rotated(angle))
		draw_colored_polygon(rotated, Color(1.0, 0.82, 0.1))
		if caption != "":
			var font := get_theme_default_font()
			var ts := font.get_string_size(caption, HORIZONTAL_ALIGNMENT_CENTER, -1, 20)
			draw_string(font, Vector2(c.x - ts.x * 0.5, size.y + 20), caption, HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color.WHITE)
