extends GutTest


func _bus(paid := 300_000, price := 1_200_000, owned := false) -> Dictionary:
	return {"price_total": price, "paid_total": paid, "owned": owned}


func test_fare_grows_with_stops():
	assert_eq(Economy.fare_for(1), Tuning.FARE_BASE)
	assert_eq(Economy.fare_for(3), Tuning.FARE_BASE + 2 * Tuning.FARE_PER_STOP)
	assert_eq(Economy.fare_for(0), Tuning.FARE_BASE, "zero stops still pays the base fare")


func test_race_prize_by_position():
	assert_eq(Economy.race_prize(1), Tuning.RACE_PRIZES[0])
	assert_eq(Economy.race_prize(4), Tuning.RACE_PRIZES[3])
	assert_eq(Economy.race_prize(9), Tuning.RACE_PRIZES[-1])
	assert_eq(Economy.race_prize(0), 0)


func test_work_settlement_breakdown():
	var s := Economy.settle({"event_id": "e1", "mode": "work", "fares": 20_000, "journeys": 18, "distance_m": 4000.0, "qualifying": true}, _bus())
	assert_eq(s["base_earnings"], 20_000)
	assert_eq(s["expenses"]["fuel"], 1_000)
	assert_eq(s["expenses"]["conductor"], 3_000)
	assert_eq(s["expenses"]["park"], Tuning.PARK_LEVY_PER_SHIFT)
	assert_eq(s["expenses_total"], 5_000)
	assert_eq(s["owner_payment"], 7_500)
	assert_eq(s["take_home"], 7_500)
	assert_eq(s["remaining_after"], 900_000 - 7_500)
	assert_false(s["newly_owned"])


func test_expenses_never_exceed_earnings():
	var s := Economy.settle({"event_id": "e2", "mode": "race", "position": 0, "distance_m": 9000.0}, _bus())
	assert_eq(s["base_earnings"], 0)
	assert_eq(s["expenses_total"], 0)
	assert_eq(s["take_home"], 0)
	assert_eq(s["owner_payment"], 0)


func test_payment_capped_at_remaining_and_marks_owned():
	var s := Economy.settle({"event_id": "e3", "mode": "race", "position": 1, "distance_m": 0.0}, _bus(1_195_000))
	assert_eq(s["owner_payment"], 5_000)
	assert_eq(s["remaining_after"], 0)
	assert_true(s["newly_owned"])
	assert_eq(s["take_home"], Tuning.RACE_PRIZES[0] - 5_000)


func test_owned_bus_pays_no_instalment():
	var s := Economy.settle({"event_id": "e4", "mode": "race", "position": 1, "distance_m": 0.0}, _bus(1_200_000, 1_200_000, true))
	assert_eq(s["owner_payment"], 0)
	assert_eq(s["take_home"], Tuning.RACE_PRIZES[0])
	assert_false(s["newly_owned"])
