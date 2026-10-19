class_name PassengerManifest
extends RefCounted
## Seats and passenger journeys for one bus. Enforces capacity, reserves a
## seat before anyone boards, and pays each journey's fare exactly once.

var capacity: int
var seats: Array[int] = [] # passenger id per seat, -1 when free
var passengers := {} # id -> Dictionary
var next_id := 1
var fares_total := 0
var journeys_completed := 0


func _init(seat_count := 14) -> void:
	capacity = seat_count
	seats.resize(seat_count)
	seats.fill(-1)


func free_seats() -> int:
	return seats.count(-1)


func occupied_seats() -> int:
	return capacity - free_seats()


func add_waiting(origin: String, destination: String, stops_travelled: int) -> int:
	var id := next_id
	next_id += 1
	passengers[id] = {
		"id": id, "origin": origin, "destination": destination,
		"stops": stops_travelled, "seat": -1, "state": "waiting",
		"fare": Economy.fare_for(stops_travelled), "paid": false,
	}
	return id


## Reserves a free seat for a waiting passenger. Returns the seat or -1.
func reserve_seat(id: int) -> int:
	var p: Dictionary = passengers.get(id, {})
	if p.is_empty() or p["state"] != "waiting":
		return -1
	var seat := seats.find(-1)
	if seat < 0:
		return -1
	seats[seat] = id
	p["seat"] = seat
	p["state"] = "boarding"
	return seat


## An interrupted boarding returns the passenger to the stop and frees the seat.
func cancel_boarding(id: int) -> void:
	var p: Dictionary = passengers.get(id, {})
	if p.is_empty() or p["state"] != "boarding":
		return
	seats[p["seat"]] = -1
	p["seat"] = -1
	p["state"] = "waiting"


func complete_boarding(id: int) -> bool:
	var p: Dictionary = passengers.get(id, {})
	if p.is_empty() or p["state"] != "boarding":
		return false
	p["state"] = "riding"
	return true


func riders_for(destination: String) -> Array[int]:
	var result: Array[int] = []
	for p in passengers.values():
		if p["state"] == "riding" and p["destination"] == destination:
			result.append(p["id"])
	return result


func riding_destinations() -> Array[String]:
	var result: Array[String] = []
	for p in passengers.values():
		if p["state"] in ["riding", "alighting"] and not result.has(p["destination"]):
			result.append(p["destination"])
	return result


func waiting_at(origin: String) -> Array[int]:
	var result: Array[int] = []
	for p in passengers.values():
		if p["state"] == "waiting" and p["origin"] == origin:
			result.append(p["id"])
	return result


func begin_alight(id: int) -> bool:
	var p: Dictionary = passengers.get(id, {})
	if p.is_empty() or p["state"] != "riding":
		return false
	p["state"] = "alighting"
	return true


## Completes a journey: frees the seat and returns the fare the first time only.
func complete_alight(id: int) -> int:
	var p: Dictionary = passengers.get(id, {})
	if p.is_empty() or p["state"] != "alighting":
		return 0
	seats[p["seat"]] = -1
	p["seat"] = -1
	p["state"] = "done"
	if p["paid"]:
		return 0
	p["paid"] = true
	fares_total += int(p["fare"])
	journeys_completed += 1
	return int(p["fare"])
