extends Node
## Career state: naira, the bus and its agreement, the payment ledger, ad
## history, rival memory and preferences. Every change that matters is saved
## immediately through SaveStore, and each event or reward applies only once.

signal changed

const SAVE_PATH := "user://danfo_save.dat"

var store := SaveStore.new(SAVE_PATH)
var data: Dictionary = {}


func _ready() -> void:
	load_or_create()
	_discard_unfinished_rewards()


func load_or_create() -> void:
	var loaded := store.load_payload()
	data = loaded if not loaded.is_empty() else default_data()
	_fill_missing(data, default_data())


func save() -> Error:
	var err := store.save(data)
	if err != OK:
		push_warning("Save failed: %s" % error_string(err))
	changed.emit()
	return err


func default_data() -> Dictionary:
	return {
		"naira": Tuning.STARTING_NAIRA,
		"selected_bus": "bus_1",
		"buses": {
			"bus_1": {
				"id": "bus_1", "model": "classic14", "label": "My Danfo",
				"price_total": Tuning.STARTING_BUS_PRICE,
				"paid_total": Tuning.STARTING_BUS_DEPOSIT,
				"owned": false, "paint": "lagos_yellow", "horn": "two_tone",
				"history": [], "stats": {"races": 0, "wins": 0, "shifts": 0, "journeys": 0},
			},
		},
		"ledger": [],
		"settled_events": {},
		"settled_order": [],
		"ad_state": AdPacing.new_state(),
		"pending_rewards": {},
		"granted_rewards": [],
		"rival_memory": {},
		"records": {},
		"prefs": {
			"control_scheme": "buttons", "steer_sensitivity": 1.0,
			"volume": 0.8, "subtitles": true, "reduced_motion": false,
		},
	}


func bus() -> Dictionary:
	return data["buses"][data["selected_bus"]]


func naira() -> int:
	return int(data["naira"])


func remaining_balance() -> int:
	var b := bus()
	return maxi(int(b["price_total"]) - int(b["paid_total"]), 0)


func ownership_fraction() -> float:
	var b := bus()
	return clampf(float(b["paid_total"]) / float(b["price_total"]), 0.0, 1.0)


func pref(key: String) -> Variant:
	return data["prefs"].get(key)


func set_pref(key: String, value: Variant) -> void:
	data["prefs"][key] = value
	save()


func set_bus_look(paint_id: String, horn_id: String) -> void:
	var b := bus()
	if Content.PAINTS.has(paint_id):
		b["paint"] = paint_id
	if Content.HORNS.has(horn_id):
		b["horn"] = horn_id
	save()


static func new_event_id(mode: String) -> String:
	return "%s-%d-%06d" % [mode, int(Time.get_unix_time_from_system()), randi() % 1000000]


## Applies a finished event exactly once and saves before returning. Calling
## again with the same event_id returns the stored settlement unchanged.
func settle_event(summary: Dictionary) -> Dictionary:
	var event_id: String = summary.get("event_id", "")
	assert(event_id != "", "Events need an id")
	if data["settled_events"].has(event_id):
		return data["settled_events"][event_id]
	var b := bus()
	var result := Economy.settle(summary, b)
	var mode: String = result["mode"]

	data["naira"] = naira() + int(result["take_home"])
	b["paid_total"] = int(b["paid_total"]) + int(result["owner_payment"])
	_ledger("earnings", int(result["base_earnings"]), event_id)
	_ledger("expenses", -int(result["expenses_total"]), event_id)
	_ledger("owner_payment", -int(result["owner_payment"]), event_id)

	var stats: Dictionary = b["stats"]
	if mode == "race":
		stats["races"] = int(stats["races"]) + 1
		if int(summary.get("position", 0)) == 1:
			stats["wins"] = int(stats["wins"]) + 1
	elif mode == "work":
		stats["journeys"] = int(stats["journeys"]) + int(summary.get("journeys", 0))
		if result["qualifying"]:
			stats["shifts"] = int(stats["shifts"]) + 1
	if result["newly_owned"]:
		b["owned"] = true
		_milestone("owned", "Paid off — the bus is yours.")
	if result["qualifying"]:
		AdPacing.record_qualifying_event(data["ad_state"])
	if mode == "race":
		_remember_rivals(summary)
		_record_time(summary)

	data["settled_events"][event_id] = result
	data["settled_order"].append(event_id)
	while data["settled_order"].size() > Tuning.SETTLED_EVENT_LIMIT:
		data["settled_events"].erase(data["settled_order"].pop_front())
	save()
	return result


func record_active_time(seconds: float) -> void:
	AdPacing.record_active_time(data["ad_state"], seconds)


func interstitial_eligible() -> bool:
	return AdPacing.interstitial_eligible(data["ad_state"], Time.get_unix_time_from_system())


func record_fullscreen_closed() -> void:
	AdPacing.record_fullscreen_closed(data["ad_state"], Time.get_unix_time_from_system())
	save()


## True when this event's result has not yet used its one rewarded offer.
func reward_offer_available(event_id: String) -> bool:
	var settled: Dictionary = data["settled_events"].get(event_id, {})
	if settled.is_empty() or int(settled["base_earnings"]) <= 0:
		return false
	return not settled.get("reward_used", false)


## Records a pending reward before the ad is shown. The amount equals the
## event's base earnings, so earlier bonuses never compound.
func begin_reward(event_id: String, placement: String) -> String:
	var settled: Dictionary = data["settled_events"][event_id]
	settled["reward_used"] = true
	var txn := "rw-%s-%s" % [event_id, placement]
	data["pending_rewards"][txn] = {
		"txn": txn, "event_id": event_id, "placement": placement,
		"amount": int(settled["base_earnings"]),
	}
	save()
	return txn


## Grants a pending reward once. Returns the amount granted (0 if already done).
func grant_reward(txn: String) -> int:
	if data["granted_rewards"].has(txn) or not data["pending_rewards"].has(txn):
		return 0
	var reward: Dictionary = data["pending_rewards"][txn]
	data["pending_rewards"].erase(txn)
	data["granted_rewards"].append(txn)
	while data["granted_rewards"].size() > Tuning.GRANTED_REWARD_LIMIT:
		data["granted_rewards"].pop_front()
	data["naira"] = naira() + int(reward["amount"])
	_ledger("reward_" + str(reward["placement"]), int(reward["amount"]), str(reward["event_id"]))
	save()
	return int(reward["amount"])


func cancel_reward(txn: String) -> void:
	if data["pending_rewards"].erase(txn):
		save()


func rival_memory(rival_id: String) -> Dictionary:
	return data["rival_memory"].get(rival_id, {})


func _remember_rivals(summary: Dictionary) -> void:
	var order: Array = summary.get("order", [])
	var mine := order.find("player")
	for i in order.size():
		var rid := str(order[i])
		if rid == "player":
			continue
		var memory: Dictionary = data["rival_memory"].get(rid, {"races": 0, "player_ahead": 0, "rival_ahead": 0})
		memory["races"] = int(memory["races"]) + 1
		if mine >= 0 and mine < i:
			memory["player_ahead"] = int(memory["player_ahead"]) + 1
		else:
			memory["rival_ahead"] = int(memory["rival_ahead"]) + 1
		memory["last_course"] = summary.get("course_id", "")
		memory["last_player_ahead"] = mine >= 0 and mine < i
		data["rival_memory"][rid] = memory


func _record_time(summary: Dictionary) -> void:
	var course: String = summary.get("course_id", "")
	var t := float(summary.get("finish_time", 0.0))
	if course == "" or t <= 0.0:
		return
	var best: Dictionary = data["records"].get(course, {})
	if best.is_empty() or t < float(best["time"]):
		data["records"][course] = {"time": t, "bus": data["selected_bus"], "physics": Bus.PHYSICS_VERSION}


func _ledger(kind: String, amount: int, event_id: String) -> void:
	if amount == 0:
		return
	data["ledger"].append({"kind": kind, "amount": amount, "event_id": event_id,
		"unix": int(Time.get_unix_time_from_system())})
	while data["ledger"].size() > Tuning.LEDGER_LIMIT:
		data["ledger"].pop_front()


func _milestone(kind: String, text: String) -> void:
	bus()["history"].append({"kind": kind, "text": text, "unix": int(Time.get_unix_time_from_system())})


## A reward whose ad never reported completion (for example, the app was
## killed mid-ad) is dropped rather than guessed at.
func _discard_unfinished_rewards() -> void:
	if not data["pending_rewards"].is_empty():
		data["pending_rewards"].clear()
		save()


static func _fill_missing(target: Dictionary, defaults: Dictionary) -> void:
	for key in defaults:
		if not target.has(key):
			target[key] = defaults[key]
		elif typeof(defaults[key]) == TYPE_DICTIONARY and typeof(target[key]) == TYPE_DICTIONARY and key in ["prefs", "ad_state"]:
			_fill_missing(target[key], defaults[key])
