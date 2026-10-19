extends GutTest

const PATH := "user://test_game_state.dat"
var gs: Node


func before_each():
	gs = load("res://autoload/game_state.gd").new()
	gs.store = SaveStore.new(PATH)
	gs.store.delete_all()
	gs.load_or_create()


func after_each():
	gs.store.delete_all()
	gs.free()


func _race(event_id: String, position := 1) -> Dictionary:
	return {"event_id": event_id, "mode": "race", "position": position, "qualifying": true,
		"distance_m": 2000.0, "course_id": "ring_road", "finish_time": 100.0,
		"order": ["player", "mama_kemi", "ayo_late_brake", "chidi_corner"]}


func test_settlement_applies_once():
	var start: int = gs.naira()
	var first: Dictionary = gs.settle_event(_race("r1"))
	var after_first: int = gs.naira()
	var again: Dictionary = gs.settle_event(_race("r1"))
	assert_eq(gs.naira(), after_first, "repeat settlement changes nothing")
	assert_eq(after_first, start + int(first["take_home"]))
	assert_eq(again, first)
	assert_eq(int(gs.data["ad_state"]["events_total"]), 1)


func test_settlement_is_saved_before_returning():
	gs.settle_event(_race("r2"))
	var reloaded := SaveStore.new(PATH).load_payload()
	assert_true(reloaded["settled_events"].has("r2"))
	assert_eq(int(reloaded["naira"]), gs.naira())


func test_paid_off_bus_stays_owned():
	gs.bus()["paid_total"] = Tuning.STARTING_BUS_PRICE - 1_000
	var s: Dictionary = gs.settle_event(_race("r3"))
	assert_true(s["newly_owned"])
	assert_true(gs.bus()["owned"])
	assert_eq(gs.remaining_balance(), 0)
	var s2: Dictionary = gs.settle_event(_race("r4"))
	assert_eq(s2["owner_payment"], 0, "no instalments after ownership")
	assert_true(gs.bus()["owned"])
	assert_eq(gs.bus()["history"].size(), 1, "milestone recorded once")


func test_reward_granted_exactly_once_and_equals_base():
	var s: Dictionary = gs.settle_event(_race("r5", 2))
	assert_true(gs.reward_offer_available("r5"))
	var txn: String = gs.begin_reward("r5", "race_bonus")
	assert_false(gs.reward_offer_available("r5"), "one offer per result")
	var before: int = gs.naira()
	assert_eq(gs.grant_reward(txn), int(s["base_earnings"]))
	assert_eq(gs.grant_reward(txn), 0, "duplicate callback grants nothing")
	assert_eq(gs.naira(), before + int(s["base_earnings"]))


func test_cancelled_reward_grants_nothing_and_keeps_base():
	gs.settle_event(_race("r6"))
	var before: int = gs.naira()
	var txn: String = gs.begin_reward("r6", "race_bonus")
	gs.cancel_reward(txn)
	assert_eq(gs.grant_reward(txn), 0)
	assert_eq(gs.naira(), before)


func test_rival_memory_records_results():
	gs.settle_event(_race("r7"))
	var memory: Dictionary = gs.rival_memory("mama_kemi")
	assert_eq(int(memory["races"]), 1)
	assert_eq(int(memory["player_ahead"]), 1)


func test_record_time_kept_with_physics_version():
	gs.settle_event(_race("r8"))
	assert_eq(float(gs.data["records"]["ring_road"]["time"]), 100.0)
	assert_eq(gs.data["records"]["ring_road"]["physics"], Bus.PHYSICS_VERSION)
