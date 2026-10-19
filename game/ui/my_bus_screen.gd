class_name MyBusScreen
extends Control
## Selected bus, paint and horn choices, and a compact ownership summary.

var preview: BusPreview


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var root := UiKit.screen(self)
	var layout := HBoxContainer.new()
	layout.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layout.alignment = BoxContainer.ALIGNMENT_CENTER
	layout.add_theme_constant_override("separation", 36)
	root.add_child(layout)

	var left := VBoxContainer.new()
	left.alignment = BoxContainer.ALIGNMENT_CENTER
	layout.add_child(left)
	var b := GameState.bus()
	UiKit.title(left, b["label"])
	preview = BusPreview.new(Vector2i(540, 300))
	left.add_child(preview)
	var stats: Dictionary = b["stats"]
	UiKit.label(left, "Races %d (wins %d)   ·   Shifts %d   ·   Journeys %d" % [stats["races"], stats["wins"], stats["shifts"], stats["journeys"]], 18, Color(0.85, 0.85, 0.82), HORIZONTAL_ALIGNMENT_CENTER)
	var history: Array = b["history"]
	if not history.is_empty():
		UiKit.label(left, "Latest: " + str(history[-1]["text"]), 18, UiKit.YELLOW, HORIZONTAL_ALIGNMENT_CENTER)

	var right := VBoxContainer.new()
	right.alignment = BoxContainer.ALIGNMENT_CENTER
	right.add_theme_constant_override("separation", 12)
	layout.add_child(right)
	UiKit.label(right, "Paint", 24, UiKit.YELLOW)
	var paints := UiKit.row(right, 10)
	for paint_id in Content.PAINTS:
		var btn := UiKit.big_button(paints, Content.PAINTS[paint_id]["label"], func(): _choose_paint(paint_id), paint_id == b["paint"], Vector2(170, 58))
		btn.add_theme_font_size_override("font_size", 20)
	UiKit.label(right, "Horn", 24, UiKit.YELLOW)
	var horns := UiKit.row(right, 10)
	for horn_id in Content.HORNS:
		var btn := UiKit.big_button(horns, Content.HORNS[horn_id]["label"], func(): _choose_horn(horn_id), horn_id == b["horn"], Vector2(170, 58))
		btn.add_theme_font_size_override("font_size", 20)

	var own := UiKit.card(right, Vector2(540, 0))
	UiKit.label(own, "Ownership", 22, UiKit.YELLOW)
	UiKit.progress_bar(own, GameState.ownership_fraction(), 500.0)
	if b["owned"]:
		UiKit.label(own, "Fully paid. No more instalments, ever.", 18)
	else:
		UiKit.label(own, "Hire purchase: %s paid of %s (deposit %s already paid). %d%% of each event's net earnings pays it down automatically. Missing days never adds arrears or interest." % [
			UiKit.money(int(b["paid_total"])), UiKit.money(int(b["price_total"])), UiKit.money(Tuning.STARTING_BUS_DEPOSIT),
			int(Tuning.INSTALMENT_SHARE * 100)], 17)
	UiKit.big_button(right, "Back", App.go_main_menu)


func _choose_paint(paint_id: String) -> void:
	GameState.set_bus_look(paint_id, GameState.bus()["horn"])
	App.go_my_bus()


func _choose_horn(horn_id: String) -> void:
	GameState.set_bus_look(GameState.bus()["paint"], horn_id)
	var player := AudioStreamPlayer.new()
	player.stream = Synth.horn(horn_id)
	add_child(player)
	player.play()
	player.finished.connect(func(): App.go_my_bus())
