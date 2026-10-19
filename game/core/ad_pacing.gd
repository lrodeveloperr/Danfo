class_name AdPacing
extends RefCounted
## Interstitial eligibility under the PRODUCT_SPEC.md advertising baseline.
## State is a plain Dictionary so it persists in the save across modes,
## restarts and backgrounding as one shared full-screen history.

const FIRST_MIN_EVENTS := 3
const FIRST_MIN_ACTIVE_SECONDS := 180.0
const LATER_MIN_EVENTS := 2
const LATER_MIN_SECONDS_SINCE_CLOSE := 180.0
const LATER_MIN_ACTIVE_SECONDS := 120.0


static func new_state() -> Dictionary:
	return {
		"events_total": 0,
		"active_seconds_total": 0.0,
		"fullscreen_count": 0,
		"last_closed_unix": -1.0,
		"events_at_last": 0,
		"active_at_last": 0.0,
	}


static func record_active_time(state: Dictionary, seconds: float) -> void:
	if seconds > 0.0:
		state["active_seconds_total"] = float(state["active_seconds_total"]) + seconds


static func record_qualifying_event(state: Dictionary) -> void:
	state["events_total"] = int(state["events_total"]) + 1


static func interstitial_eligible(state: Dictionary, now_unix: float) -> bool:
	var events := int(state["events_total"])
	var active := float(state["active_seconds_total"])
	if int(state["fullscreen_count"]) == 0:
		return events >= FIRST_MIN_EVENTS and active >= FIRST_MIN_ACTIVE_SECONDS
	var events_since := events - int(state["events_at_last"])
	var active_since := active - float(state["active_at_last"])
	var seconds_since_close := now_unix - float(state["last_closed_unix"])
	return (events_since >= LATER_MIN_EVENTS
		and seconds_since_close >= LATER_MIN_SECONDS_SINCE_CLOSE
		and active_since >= LATER_MIN_ACTIVE_SECONDS)


## Call when any displayed full-screen ad (interstitial or rewarded) closes.
## A displayed rewarded ad therefore resets the shared spacing anchor too.
static func record_fullscreen_closed(state: Dictionary, now_unix: float) -> void:
	state["fullscreen_count"] = int(state["fullscreen_count"]) + 1
	state["last_closed_unix"] = now_unix
	state["events_at_last"] = int(state["events_total"])
	state["active_at_last"] = float(state["active_seconds_total"])
