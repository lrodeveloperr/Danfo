extends GutTest
## Drives the real App flow: race on autopilot -> settlement saved before the
## results screen -> rewarded bonus granted once -> Next starts another race.

var app: Node
var saved_data: Dictionary


func before_all():
	app = get_tree().root.get_node("App")
	app.test_autopilot = true
	saved_data = GameState.data.duplicate(true)
	GameState.store = SaveStore.new("user://test_app_flow.dat")
	GameState.store.delete_all()
	GameState.data = GameState.default_data()


func after_all():
	GameState.store.delete_all()
	GameState.store = SaveStore.new(GameState.SAVE_PATH)
	GameState.data = saved_data
	app.test_autopilot = false
	if app.current and is_instance_valid(app.current):
		app.current.queue_free()
	app.current = null


func test_race_to_results_to_reward_to_next():
	var holder := Node.new()
	add_child_autofree(holder)
	app.root = holder
	app.start_race("ring_road", "normal")
	var start_naira := GameState.naira()
	var seconds := 0
	while not (app.current is ResultsScreen) and seconds < 300:
		await wait_physics_frames(60)
		seconds += 1
	assert_true(app.current is ResultsScreen, "results screen shown")
	var results: ResultsScreen = app.current
	var event_id: String = results.settlement["event_id"]
	assert_true(GameState.data["settled_events"].has(event_id), "settled before results")
	var reloaded := SaveStore.new("user://test_app_flow.dat").load_payload()
	assert_true(reloaded["settled_events"].has(event_id), "saved to disk before results")
	assert_eq(GameState.naira(), start_naira + int(results.settlement["take_home"]))

	# Optional rewarded bonus: headless ads complete immediately and grant once.
	var before := GameState.naira()
	results._take_offer(event_id, "race_bonus")
	await wait_process_frames(2)
	assert_eq(GameState.naira(), before + int(results.settlement["base_earnings"]))
	assert_false(GameState.reward_offer_available(event_id), "only one offer per result")
	assert_true(results.rewarded_shown)

	# Next: a rewarded display suppresses the interstitial; a new race starts.
	app.after_results(app.next_event, results)
	await wait_process_frames(3)
	assert_true(app.current is RaceMode, "next race started")
	assert_eq((app.current as RaceMode).course_id, "inner_loop")
