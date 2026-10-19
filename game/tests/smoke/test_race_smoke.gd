extends GutTest
## Drives a whole race with every bus (the player's included) on AI and checks
## it reaches a real finish with a sane result. Run with --fixed-fps 60.


func _run_race(course: String) -> Dictionary:
	var result := {}
	var race := RaceMode.new()
	race.autopilot = true
	race.course_id = course
	race.finished.connect(func(summary): result.merge(summary))
	add_child_autofree(race)
	var seconds := 0
	while result.is_empty() and seconds < 400:
		await wait_physics_frames(60)
		seconds += 1
	return result


func test_ring_road_race_finishes():
	var result := await _run_race("ring_road")
	assert_false(result.is_empty(), "race reached its finish")
	assert_eq(result.get("mode"), "race")
	assert_true(result.get("qualifying", false))
	assert_between(int(result.get("position", 0)), 1, 4)
	assert_eq(result.get("order", []).size(), 4)
	assert_gt(float(result.get("distance_m", 0.0)), 1500.0)
	gut.p("ring_road: position %s, time %.1fs" % [result.get("position"), result.get("finish_time")])


func test_inner_loop_race_finishes():
	var result := await _run_race("inner_loop")
	assert_false(result.is_empty(), "race reached its finish")
	assert_true(result.get("qualifying", false))
	gut.p("inner_loop: position %s, time %.1fs" % [result.get("position"), result.get("finish_time")])
