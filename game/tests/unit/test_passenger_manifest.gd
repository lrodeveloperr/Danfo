extends GutTest


func test_capacity_is_enforced():
	var m := PassengerManifest.new(2)
	var ids := []
	for i in 3:
		ids.append(m.add_waiting("A", "B", 1))
	assert_ne(m.reserve_seat(ids[0]), -1)
	assert_ne(m.reserve_seat(ids[1]), -1)
	assert_eq(m.reserve_seat(ids[2]), -1, "no seat beyond capacity")
	assert_eq(m.free_seats(), 0)


func test_full_journey_pays_fare_once():
	var m := PassengerManifest.new(14)
	var id := m.add_waiting("Garage", "Under Bridge", 3)
	m.reserve_seat(id)
	assert_true(m.complete_boarding(id))
	assert_eq(m.riders_for("Under Bridge"), [id])
	assert_true(m.begin_alight(id))
	var fare := m.complete_alight(id)
	assert_eq(fare, Economy.fare_for(3))
	assert_eq(m.complete_alight(id), 0, "second completion pays nothing")
	assert_eq(m.fares_total, fare)
	assert_eq(m.journeys_completed, 1)
	assert_eq(m.free_seats(), 14)


func test_cancelled_boarding_releases_seat_without_fare():
	var m := PassengerManifest.new(1)
	var id := m.add_waiting("A", "B", 1)
	m.reserve_seat(id)
	m.cancel_boarding(id)
	assert_eq(m.free_seats(), 1)
	assert_eq(m.passengers[id]["state"], "waiting")
	assert_eq(m.waiting_at("A"), [id])
	assert_eq(m.fares_total, 0)


func test_cannot_alight_someone_not_riding():
	var m := PassengerManifest.new(4)
	var id := m.add_waiting("A", "B", 1)
	assert_false(m.begin_alight(id))
	assert_eq(m.complete_alight(id), 0)


func test_riding_destinations_unique():
	var m := PassengerManifest.new(4)
	for dest in ["B", "B", "C"]:
		var id := m.add_waiting("A", dest, 1)
		m.reserve_seat(id)
		m.complete_boarding(id)
	var dests := m.riding_destinations()
	dests.sort()
	assert_eq(dests, ["B", "C"])
