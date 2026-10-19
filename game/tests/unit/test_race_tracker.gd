extends GutTest

var tracker: RaceTracker


func before_each():
	tracker = RaceTracker.new()
	# 100 m square loop, travelling +X first.
	tracker.setup(PackedVector3Array([Vector3(0, 0, 0), Vector3(100, 0, 0), Vector3(100, 0, 100), Vector3(0, 0, 100)]), 2)


func _drive(id, to_distance: float, step := 10.0, time := 0.0) -> bool:
	var finished := false
	var d: float = tracker.racers[id]["total"]
	while d < to_distance:
		d = minf(d + step, to_distance)
		finished = tracker.update(id, _point_at(d), time) or finished
	return finished


func _point_at(d: float) -> Vector3:
	var local := fposmod(d, 400.0)
	if local < 100.0:
		return Vector3(local, 0, 0)
	if local < 200.0:
		return Vector3(100, 0, local - 100.0)
	if local < 300.0:
		return Vector3(300.0 - local, 0, 100)
	return Vector3(0, 0, 400.0 - local)


func test_length_and_distance():
	assert_almost_eq(tracker.length, 400.0, 0.01)
	assert_almost_eq(tracker.race_distance(), 800.0, 0.01)


func test_grid_behind_line_is_negative_progress():
	tracker.register("p", Vector3(0, 0, 10))
	assert_almost_eq(float(tracker.racers["p"]["total"]), -10.0, 0.01)


func test_progress_accumulates_over_laps_and_finishes():
	tracker.register("p", Vector3(0, 0, 0))
	assert_false(_drive("p", 790.0))
	assert_eq(tracker.lap_of("p"), 2)
	assert_true(_drive("p", 800.0, 10.0, 61.5))
	assert_eq(tracker.racers["p"]["finish_time"], 61.5)


func test_shortcut_jump_is_ignored():
	tracker.register("p", Vector3(0, 0, 0))
	tracker.update("p", Vector3(10, 0, 0), 0.0)
	tracker.update("p", Vector3(0, 0, 90), 0.0) # cut across to near the end
	assert_almost_eq(float(tracker.racers["p"]["total"]), 10.0, 0.01)


func test_standings_order():
	for id in ["a", "b", "c"]:
		tracker.register(id, Vector3.ZERO)
	_drive("a", 120.0)
	_drive("b", 300.0)
	_drive("c", 800.0, 10.0, 70.0)
	assert_eq(tracker.standings(), ["c", "b", "a"])
	assert_eq(tracker.position_of("b"), 2)
