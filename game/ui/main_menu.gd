class_name MainMenu
extends Control
## Selected bus, naira, ownership progress; Work and Race dominate, with small
## My Bus and Settings entries (PRODUCT_SPEC.md minimal menus).


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var root := UiKit.screen(self)
	var layout := HBoxContainer.new()
	layout.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layout.add_theme_constant_override("separation", 40)
	layout.alignment = BoxContainer.ALIGNMENT_CENTER
	root.add_child(layout)

	var left := VBoxContainer.new()
	left.alignment = BoxContainer.ALIGNMENT_CENTER
	left.add_theme_constant_override("separation", 10)
	layout.add_child(left)
	UiKit.title(left, "DANFO", 64)
	left.add_child(BusPreview.new())
	var b := GameState.bus()
	UiKit.label(left, "%s   ·   %s" % [b["label"], UiKit.money(GameState.naira())], 26, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	UiKit.progress_bar(left, GameState.ownership_fraction(), 520.0)
	var own_text := "Bus fully paid — it's yours." if b["owned"] else "%s left to own this bus" % UiKit.money(GameState.remaining_balance())
	UiKit.label(left, own_text, 20, Color(0.85, 0.85, 0.8), HORIZONTAL_ALIGNMENT_CENTER)

	var right := VBoxContainer.new()
	right.alignment = BoxContainer.ALIGNMENT_CENTER
	right.add_theme_constant_override("separation", 18)
	layout.add_child(right)
	UiKit.big_button(right, "WORK", App.go_work_select, true, Vector2(380, 120))
	UiKit.label(right, "Carry passengers on a route", 18, Color(0.8, 0.8, 0.78), HORIZONTAL_ALIGNMENT_CENTER)
	UiKit.big_button(right, "RACE", App.go_race_select, true, Vector2(380, 120))
	UiKit.label(right, "Beat rival danfos on a course", 18, Color(0.8, 0.8, 0.78), HORIZONTAL_ALIGNMENT_CENTER)
	var small := UiKit.row(right)
	UiKit.big_button(small, "My Bus", App.go_my_bus, false, Vector2(182, 60))
	UiKit.big_button(small, "Settings", App.go_settings, false, Vector2(182, 60))
