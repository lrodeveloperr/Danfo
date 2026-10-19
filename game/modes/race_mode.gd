class_name RaceMode
extends DriveScene
## Race: the player and three rival danfos on a defined course. No civilian
## traffic or pedestrians on the racing line; contact is part of racing.

const RIVAL_LINES := {
	"first": ["%s: Lagos road no be for learner o!", "%s: Make we see wetin you get."],
	"player_ahead": ["%s: You beat me last time. Not today.", "%s: Ehen, the one wey dey run. I remember you."],
	"rival_ahead": ["%s: Back for another lesson?", "%s: Last time you chop my dust."],
}

var course_id := "ring_road"
var difficulty := "normal"
var tracker := RaceTracker.new()
var racers := {} # id -> Bus
var path := PackedVector3Array()
var countdown := 3.6
var racing := false
var race_time := 0.0
var _last_count := 4
var _guide := BusAI.new()


func setup_mode() -> void:
	event_id = GameState.new_event_id("race")
	var course: Dictionary = Content.COURSES[course_id]
	var corners := layout.loop_points_from_mid(course["loop"])
	tracker.setup(corners, int(course["laps"]))
	path = BusAI.densify(corners, true, 4.0)
	var start := corners[0]
	var dir := (corners[1] - corners[0]).normalized()
	var right := RoadGraph.right_of(dir)
	var facing := Basis.looking_at(dir, Vector3.UP)
	# Grid: two columns, the player starts at the back.
	var slots := [right * -2.3 - dir * 7.0, right * 2.3 - dir * 7.0, right * 2.3 - dir * 16.0, right * -2.3 - dir * 16.0]
	var diff: Dictionary = Content.DIFFICULTIES[difficulty]
	var i := 0
	for rival_id in Content.RIVALS:
		var r: Dictionary = Content.RIVALS[rival_id]
		var bus := Bus.create("classic14", r["paint"], r["slogan"], 0.5 + i * 0.15, i * 97 + 5)
		bus.name = rival_id
		add_child(bus)
		bus.place_at(start + slots[i], facing)
		bus.set_racing(true)
		bus.bounds = layout.half_extent() + DistrictLayout.ROAD_WIDTH
		bus.enable_audio(r["horn"], false)
		var ai := BusAI.new()
		ai.set_path(path, true, start + slots[i])
		ai.lane_offset = float(r["lane_bias"])
		ai.speed_factor = float(r["speed"]) * float(diff["speed"])
		ai.corner_factor = float(r["corner"]) * float(diff["corner"])
		ai.brake_late = float(r["brake_late"])
		ai.defend = float(r["defend"])
		bus.driver = ai
		bus.controls_locked = true
		racers[rival_id] = bus
		i += 1
	spawn_player(start + slots[3], facing)
	player.set_racing(true)
	player.controls_locked = true
	racers["player"] = player
	if autopilot:
		var ai := BusAI.new()
		ai.set_path(path, true, player.global_position)
		ai.speed_factor = 1.02
		player.driver = ai
	for id in racers:
		tracker.register(id, racers[id].global_position)
	_guide.set_path(path, true, player.global_position)
	_greet_rival()


func _greet_rival() -> void:
	var ids := Content.RIVALS.keys()
	var rid: String = ids[randi() % ids.size()]
	var memory := GameState.rival_memory(rid)
	var pool: Array = RIVAL_LINES["first"]
	if not memory.is_empty():
		pool = RIVAL_LINES["player_ahead"] if memory.get("last_player_ahead", false) else RIVAL_LINES["rival_ahead"]
	hud.show_toast(pool[randi() % pool.size()] % Content.RIVALS[rid]["label"], 3.5)


func mode_physics(delta: float) -> void:
	if not racing:
		countdown -= delta
		var n := int(ceil(countdown))
		if n != _last_count:
			_last_count = n
			hud.set_banner(str(n) if n > 0 else "GO!")
		if countdown <= 0.0:
			racing = true
			for bus in racers.values():
				bus.controls_locked = false
		return
	race_time += delta
	if race_time > 1.0 and race_time < 1.2:
		hud.set_banner("")
	for id in racers:
		tracker.update(id, racers[id].global_position, race_time)
	var lap := tracker.lap_of("player")
	hud.set_info("Lap %d/%d   Position %d/%d   %s" % [lap, tracker.laps, tracker.position_of("player"), racers.size(), _clock(race_time)])
	_guide._index = _guide._closest_index(player.global_position, _guide._index, 24)
	hud.set_guidance(player, _guide._point_ahead(30.0))
	if tracker.racers["player"]["finished"]:
		_finish_race(true)
	elif race_time > 600.0:
		_finish_race(false)


func _finish_race(completed: bool) -> void:
	var order := tracker.standings()
	var order_ids: Array = []
	for id in order:
		order_ids.append(str(id))
	finish({
		"mode": "race", "course_id": course_id, "difficulty": difficulty,
		"position": tracker.position_of("player"), "racers": racers.size(),
		"finish_time": race_time if completed else 0.0, "qualifying": completed,
		"order": order_ids,
	})


static func _clock(t: float) -> String:
	return "%d:%04.1f" % [int(t / 60.0), fmod(t, 60.0)]
