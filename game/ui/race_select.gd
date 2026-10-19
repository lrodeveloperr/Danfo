class_name RaceSelect
extends Control
## Course cards with rivals and best time; difficulty is chosen before the
## event and stays fixed through it.

var difficulty := "normal"
var _diff_buttons := {}


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var root := UiKit.screen(self)
	var box := UiKit.centered_column(root, 12)
	UiKit.title(box, "Race")
	var diff_row := UiKit.row(box)
	for d in Content.DIFFICULTIES:
		_diff_buttons[d] = UiKit.big_button(diff_row, Content.DIFFICULTIES[d]["label"], func(): _set_difficulty(d), false, Vector2(170, 56))
	_set_difficulty(difficulty)
	var cards := UiKit.row(box, 18)
	for course_id in Content.COURSES:
		var c: Dictionary = Content.COURSES[course_id]
		var card := UiKit.card(cards, Vector2(440, 0))
		UiKit.label(card, c["label"], 28, UiKit.YELLOW)
		UiKit.label(card, c["description"], 18)
		var best: Dictionary = GameState.data["records"].get(course_id, {})
		var best_text := "Best: —" if best.is_empty() else "Best: %s" % RaceMode._clock(float(best["time"]))
		UiKit.label(card, "%d lap%s   ·   %s" % [c["laps"], "" if int(c["laps"]) == 1 else "s", best_text], 18, Color(0.85, 0.85, 0.82))
		UiKit.big_button(card, "Start race", func(): App.start_race(course_id, difficulty), true, Vector2(380, 64))
	var rivals := UiKit.card(box, Vector2(900, 0))
	UiKit.label(rivals, "Rivals", 22, UiKit.YELLOW)
	for rid in Content.RIVALS:
		var r: Dictionary = Content.RIVALS[rid]
		var m := GameState.rival_memory(rid)
		var record := "first meeting" if m.is_empty() else "you ahead %d, them ahead %d" % [m["player_ahead"], m["rival_ahead"]]
		UiKit.label(rivals, "%s — %s  (%s)" % [r["label"], str(r["tactic"]).replace("_", " "), record], 18)
	UiKit.big_button(box, "Back", App.go_main_menu)


func _set_difficulty(d: String) -> void:
	difficulty = d
	for key in _diff_buttons:
		var b: Button = _diff_buttons[key]
		b.modulate = Color(1, 1, 1) if key == d else Color(0.6, 0.6, 0.6)
