class_name ResultsScreen
extends Control
## One concise result breakdown: earnings, expenses, owner payment, take-home
## and ownership progress, saved before this screen appears. At most one
## optional rewarded offer; Next, Replay or My Bus.

var summary: Dictionary
var settlement: Dictionary
var rewarded_shown := false
var _offer: Button
var _naira_label: Label


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var root := UiKit.screen(self)
	var box := UiKit.centered_column(root, 10)
	var mode: String = summary.get("mode", "")
	if mode == "race":
		var pos := int(summary.get("position", 0))
		var heading := "You won!" if pos == 1 else "Finished %s" % _ordinal(pos)
		if not summary.get("qualifying", false):
			heading = "Race over"
		UiKit.title(box, heading)
		if float(summary.get("finish_time", 0.0)) > 0.0:
			UiKit.label(box, Content.COURSES[summary["course_id"]]["label"] + "   ·   " + RaceMode._clock(float(summary["finish_time"])), 22, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	else:
		UiKit.title(box, "Shift complete" if summary.get("qualifying", false) else "Shift ended")
		UiKit.label(box, "%d journeys" % int(summary.get("journeys", 0)), 22, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)

	var card := UiKit.card(box, Vector2(620, 0))
	_line(card, "Race prize" if mode == "race" else "Fares collected", int(settlement["base_earnings"]))
	var ex: Dictionary = settlement["expenses"]
	var applied := int(settlement["expenses_total"])
	var listed := int(ex["fuel"]) + int(ex["conductor"]) + int(ex["park"])
	if int(ex["fuel"]) > 0:
		_line(card, "Fuel", -int(ex["fuel"]))
	if int(ex["conductor"]) > 0:
		_line(card, "Conductor", -int(ex["conductor"]))
	if int(ex["park"]) > 0:
		_line(card, "Park levy", -int(ex["park"]))
	if listed > applied:
		_line(card, "Costs covered (no earnings)", listed - applied)
	_line(card, "Bus payment", -int(settlement["owner_payment"]))
	_line(card, "Take-home", int(settlement["take_home"]), true)
	UiKit.progress_bar(card, GameState.ownership_fraction(), 580.0)
	if settlement.get("newly_owned", false):
		UiKit.label(card, "Paid off! The bus is yours for good.", 22, UiKit.YELLOW)
	elif GameState.bus()["owned"]:
		UiKit.label(card, "Your bus is fully owned.", 18)
	else:
		UiKit.label(card, "%s left to own your bus" % UiKit.money(GameState.remaining_balance()), 18)
	_naira_label = UiKit.label(card, "Balance: %s" % UiKit.money(GameState.naira()), 20, Color.WHITE)

	var event_id: String = settlement["event_id"]
	if GameState.reward_offer_available(event_id) and Ads.rewarded_ready():
		var amount := int(settlement["base_earnings"])
		var placement := "race_bonus" if mode == "race" else "shift_bonus"
		_offer = UiKit.big_button(box, "Watch an ad: +%s bonus" % UiKit.money(amount), func(): _take_offer(event_id, placement), false, Vector2(620, 64))
		UiKit.label(box, "Optional. Game naira are fictional and have no cash value. Your earnings above are already saved.", 15, Color(0.7, 0.7, 0.68), HORIZONTAL_ALIGNMENT_CENTER)

	var buttons := UiKit.row(box)
	UiKit.big_button(buttons, "Next", func(): App.after_results(App.next_event, self), true, Vector2(220, 72))
	UiKit.big_button(buttons, "Replay", func(): App.after_results(App.replay, self), false, Vector2(200, 72))
	UiKit.big_button(buttons, "My Bus", App.go_my_bus, false, Vector2(200, 72))


func _line(parent: Node, label_text: String, amount: int, bold := false) -> void:
	var r := HBoxContainer.new()
	parent.add_child(r)
	var l := UiKit.label(r, label_text, 24 if bold else 20, UiKit.YELLOW if bold else Color(0.9, 0.9, 0.88))
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	l.autowrap_mode = TextServer.AUTOWRAP_OFF
	var value := UiKit.label(r, UiKit.money(amount), 24 if bold else 20, UiKit.YELLOW if bold else Color.WHITE)
	value.autowrap_mode = TextServer.AUTOWRAP_OFF


func _take_offer(event_id: String, placement: String) -> void:
	_offer.disabled = true
	var txn := GameState.begin_reward(event_id, placement)
	Ads.show_rewarded(txn)
	var result: Array = await Ads.rewarded_finished
	rewarded_shown = true
	GameState.record_fullscreen_closed()
	if result[1]:
		var granted := GameState.grant_reward(txn)
		_offer.text = "Bonus added: +%s" % UiKit.money(granted)
	else:
		GameState.cancel_reward(txn)
		_offer.text = "No bonus this time"
	_naira_label.text = "Balance: %s" % UiKit.money(GameState.naira())


static func _ordinal(n: int) -> String:
	match n:
		1: return "1st"
		2: return "2nd"
		3: return "3rd"
	return "%dth" % n
