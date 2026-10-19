extends GutTest
## Drives a whole passenger shift on autopilot through traffic and checks that
## journeys complete, each fare is paid once, and seats never overflow.


func test_shift_completes_with_fares_paid_once():
	var result := {}
	var work := WorkMode.new()
	work.autopilot = true
	work.finished.connect(func(summary): result.merge(summary))
	add_child_autofree(work)
	var seconds := 0
	var max_occupied := 0
	while result.is_empty() and seconds < 900:
		await wait_physics_frames(60)
		seconds += 1
		max_occupied = maxi(max_occupied, work.manifest.occupied_seats())
	assert_false(result.is_empty(), "shift completed within 15 simulated minutes")
	assert_true(result.get("qualifying", false))
	var target := int(Content.ROUTES["garage_loop"]["journeys_target"])
	assert_gte(int(result.get("journeys", 0)), target)
	assert_lte(max_occupied, work.manifest.capacity, "never over capacity")
	var paid_sum := 0
	var paid_count := 0
	for p in work.manifest.passengers.values():
		if p["paid"]:
			paid_sum += int(p["fare"])
			paid_count += 1
	assert_eq(int(result.get("fares", -1)), paid_sum, "fares equal the sum of paid journeys")
	assert_eq(paid_count, int(result.get("journeys", -1)), "one fare per completed journey")
	gut.p("shift: %d journeys, fares %d, %d s simulated" % [result.get("journeys"), result.get("fares"), seconds])
