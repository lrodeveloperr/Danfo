extends GutTest

var layout: DistrictLayout


func before_all():
	layout = DistrictLayout.new()
	layout.generate()


func test_road_network_is_connected():
	assert_true(layout.graph.is_fully_connected())


func test_every_route_stop_exists_and_is_reachable():
	for route_id in Content.ROUTES:
		for stop_name in Content.ROUTES[route_id]["stops"]:
			assert_true(layout.stops_by_name.has(stop_name), "stop placed: %s" % stop_name)
	var garage: Dictionary = layout.stops_by_name["Garage"]
	for stop in layout.stops:
		var path := layout.graph.path_ids(garage["a"], stop["a"])
		assert_gt(path.size(), 0, "reachable: %s" % stop["name"])


func test_stop_sides_face_opposite_directions_on_the_right_kerb():
	for stop in layout.stops:
		var sides: Array = stop["sides"]
		assert_eq(sides.size(), 2)
		for side in sides:
			var right := RoadGraph.right_of(side["direction"])
			var offset: Vector3 = side["stop_point"] - stop["center"]
			assert_almost_eq(offset.dot(right), DistrictLayout.STOP_LANE_OFFSET, 0.01, "%s kerbside" % stop["name"])


func test_race_loops_are_closed_roads():
	for loop_name in ["outer", "inner"]:
		assert_true(layout.loop_is_valid(loop_name), loop_name)


func test_all_stop_names_unique():
	var seen := {}
	for stop in layout.stops:
		assert_false(seen.has(stop["name"]))
		seen[stop["name"]] = true


func test_right_of_forward_is_positive_x():
	assert_almost_eq(RoadGraph.right_of(Vector3.FORWARD).x, 1.0, 0.0001)
