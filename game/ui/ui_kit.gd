class_name UiKit
extends RefCounted
## Helpers for the minimal menus: large touch targets, consistent type sizes.

const YELLOW := Color(0.98, 0.78, 0.05)
const INK := Color(0.07, 0.07, 0.07)
const PANEL := Color(0.1, 0.1, 0.11, 0.92)


static func screen(parent: Node) -> Control:
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var bg := ColorRect.new()
	bg.color = Color(0.11, 0.1, 0.09)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(bg)
	# Two stripes echo the danfo livery.
	for y in [0.968, 0.986]:
		var stripe := ColorRect.new()
		stripe.color = YELLOW if y < 0.98 else Color(0.2, 0.18, 0.1)
		stripe.anchor_left = 0.0
		stripe.anchor_right = 1.0
		stripe.anchor_top = y
		stripe.anchor_bottom = y + 0.01
		root.add_child(stripe)
	parent.add_child(root)
	return root


static func centered_column(parent: Node, separation := 16) -> VBoxContainer:
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	parent.add_child(center)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", separation)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(box)
	return box


static func title(parent: Node, text: String, size := 44) -> Label:
	return label(parent, text, size, YELLOW, HORIZONTAL_ALIGNMENT_CENTER)


static func label(parent: Node, text: String, size := 24, color := Color(0.94, 0.94, 0.92), align := HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.horizontal_alignment = align
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	parent.add_child(l)
	return l


static func big_button(parent: Node, text: String, on_press: Callable, primary := false, min_size := Vector2(360, 72)) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = min_size
	b.add_theme_font_size_override("font_size", 30 if primary else 24)
	var normal := StyleBoxFlat.new()
	normal.bg_color = YELLOW if primary else Color(0.2, 0.2, 0.21)
	normal.set_corner_radius_all(12)
	normal.content_margin_left = 18
	normal.content_margin_right = 18
	var hover := normal.duplicate()
	hover.bg_color = normal.bg_color.lightened(0.12)
	b.add_theme_stylebox_override("normal", normal)
	b.add_theme_stylebox_override("hover", hover)
	b.add_theme_stylebox_override("pressed", hover)
	b.add_theme_stylebox_override("focus", hover)
	b.add_theme_color_override("font_color", INK if primary else Color(0.95, 0.95, 0.92))
	b.add_theme_color_override("font_hover_color", INK if primary else Color.WHITE)
	b.add_theme_color_override("font_pressed_color", INK if primary else Color.WHITE)
	b.pressed.connect(on_press)
	parent.add_child(b)
	return b


static func card(parent: Node, min_size := Vector2(520, 0)) -> VBoxContainer:
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = PANEL
	style.set_corner_radius_all(14)
	style.set_content_margin_all(20)
	panel.add_theme_stylebox_override("panel", style)
	panel.custom_minimum_size = min_size
	parent.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)
	return box


static func row(parent: Node, separation := 14) -> HBoxContainer:
	var r := HBoxContainer.new()
	r.add_theme_constant_override("separation", separation)
	r.alignment = BoxContainer.ALIGNMENT_CENTER
	parent.add_child(r)
	return r


static func money(amount: int) -> String:
	var negative := amount < 0
	var digits := str(absi(amount))
	var out := ""
	while digits.length() > 3:
		out = "," + digits.substr(digits.length() - 3) + out
		digits = digits.substr(0, digits.length() - 3)
	return ("-" if negative else "") + "₦" + digits + out


static func progress_bar(parent: Node, fraction: float, width := 420.0) -> ProgressBar:
	var bar := ProgressBar.new()
	bar.min_value = 0.0
	bar.max_value = 1.0
	bar.value = fraction
	bar.show_percentage = false
	bar.custom_minimum_size = Vector2(width, 18)
	var fill := StyleBoxFlat.new()
	fill.bg_color = YELLOW
	fill.set_corner_radius_all(6)
	var back := StyleBoxFlat.new()
	back.bg_color = Color(0.25, 0.25, 0.25)
	back.set_corner_radius_all(6)
	bar.add_theme_stylebox_override("fill", fill)
	bar.add_theme_stylebox_override("background", back)
	parent.add_child(bar)
	return bar
