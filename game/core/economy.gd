class_name Economy
extends RefCounted
## Pure settlement rules for a finished event. GameState applies the result once.


## Fare for one completed journey that travelled `stops_travelled` stops.
static func fare_for(stops_travelled: int) -> int:
	return Tuning.FARE_BASE + Tuning.FARE_PER_STOP * maxi(stops_travelled - 1, 0)


static func race_prize(position: int) -> int:
	if position < 1:
		return 0
	var index := mini(position - 1, Tuning.RACE_PRIZES.size() - 1)
	return Tuning.RACE_PRIZES[index]


## Returns the settlement breakdown for `summary` against the bus agreement in
## `bus` ({price_total, paid_total, owned}). Expenses never exceed what the
## event earned, and the owner payment never exceeds the remaining balance, so a
## played event can never create arrears.
static func settle(summary: Dictionary, bus: Dictionary) -> Dictionary:
	var mode: String = summary.get("mode", "")
	var base := 0
	var expenses := {"fuel": 0, "conductor": 0, "park": 0}
	var km: float = float(summary.get("distance_m", 0.0)) / 1000.0
	expenses["fuel"] = int(round(km * Tuning.FUEL_COST_PER_KM))
	if mode == "work":
		base = int(summary.get("fares", 0))
		expenses["conductor"] = int(round(base * Tuning.CONDUCTOR_SHARE))
		if int(summary.get("journeys", 0)) > 0:
			expenses["park"] = Tuning.PARK_LEVY_PER_SHIFT
	elif mode == "race":
		base = race_prize(int(summary.get("position", 0)))

	var expenses_total := 0
	for value in expenses.values():
		expenses_total += int(value)
	var expenses_applied := mini(expenses_total, base)
	var net := base - expenses_applied

	var price_total := int(bus.get("price_total", 0))
	var paid_total := int(bus.get("paid_total", 0))
	var remaining_before := maxi(price_total - paid_total, 0)
	var owned_before: bool = bus.get("owned", false) or remaining_before == 0
	var owner_payment := 0
	if not owned_before:
		owner_payment = mini(int(floor(net * Tuning.INSTALMENT_SHARE)), remaining_before)
	var remaining_after := remaining_before - owner_payment

	return {
		"event_id": summary.get("event_id", ""),
		"mode": mode,
		"qualifying": bool(summary.get("qualifying", false)),
		"base_earnings": base,
		"expenses": expenses,
		"expenses_total": expenses_applied,
		"owner_payment": owner_payment,
		"take_home": net - owner_payment,
		"remaining_before": remaining_before,
		"remaining_after": remaining_after,
		"newly_owned": not owned_before and remaining_after == 0,
	}
