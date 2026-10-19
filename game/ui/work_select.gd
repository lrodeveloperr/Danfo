class_name WorkSelect
extends Control
## A concise service-route card with destinations, duration and demand cues,
## and the disclosed fare and cost terms.


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var root := UiKit.screen(self)
	var box := UiKit.centered_column(root, 14)
	UiKit.title(box, "Work a route")
	for route_id in Content.ROUTES:
		var r: Dictionary = Content.ROUTES[route_id]
		var card := UiKit.card(box, Vector2(760, 0))
		UiKit.label(card, r["label"], 30, UiKit.YELLOW)
		UiKit.label(card, r["description"], 20)
		UiKit.label(card, "Stops: " + " → ".join(r["stops"]), 18, Color(0.85, 0.85, 0.82))
		UiKit.label(card, "Shift: %d journeys, %s   ·   Demand: %s" % [r["journeys_target"], r["duration_hint"], r["demand"]], 18, Color(0.85, 0.85, 0.82))
		UiKit.label(card, "Fares: %s per journey + %s per extra stop. Costs: fuel, conductor %d%% of fares, park levy %s. %d%% of what's left pays down your bus automatically." % [
			UiKit.money(Tuning.FARE_BASE), UiKit.money(Tuning.FARE_PER_STOP), int(Tuning.CONDUCTOR_SHARE * 100),
			UiKit.money(Tuning.PARK_LEVY_PER_SHIFT), int(Tuning.INSTALMENT_SHARE * 100)], 16, Color(0.75, 0.75, 0.72))
		UiKit.big_button(card, "Start shift", func(): App.start_work(route_id), true)
	UiKit.big_button(box, "Back", App.go_main_menu)
