class_name WorkMode
extends DriveScene
## Work: an open-world passenger shift on an advertised danfo route. Stop
## stationary at a stop with the door facing the kerb; people getting down
## leave first, then waiting passengers take reserved seats. The conductor
## collects each fare once when its journey completes.

const SERVICE_RADIUS := 7.5
const ALIGN_DOT := 0.6
## Stopped at the chosen stop this long with nothing happening: re-plan.
const STUCK_AT_STOP := 6.0
const ALIGHT_STEP := 0.7
const BOARD_TIMEOUT := 4.0
const MAX_WAITING := 6

var route_id := "garage_loop"
## Fixed demand for tests; 0 means random each shift.
var rng_seed := 0
var route: Dictionary
var stops: Array[String] = []
var manifest: PassengerManifest
var traffic: Traffic
var figures := {} # passenger id -> Pedestrian
var kerb_of := {} # waiting passenger id -> stop side index they wait on
var service := {}
var target_stop := ""
var guide_points := PackedVector3Array()
var rng := RandomNumberGenerator.new()
var _target_key := ""
var _target_point := Vector3.ZERO
var _guide_timer := 0.0
var _demand_timer := 0.0
var _owa_called := ""
var _autopilot_ai: BusAI
var _served_at := {} # stop name -> elapsed time it was last served
var _idle_at_target := 0.0
var _marker: MeshInstance3D


func setup_mode() -> void:
	event_id = GameState.new_event_id("work")
	rng.seed = rng_seed if rng_seed != 0 else Time.get_ticks_usec()
	route = Content.ROUTES[route_id]
	for s in route["stops"]:
		stops.append(s)
	var model: Dictionary = Content.BUS_MODELS[GameState.bus()["model"]]
	manifest = PassengerManifest.new(int(model["seats"]))
	var garage_side: Dictionary = layout.stops_by_name[stops[0]]["sides"][0]
	var dir: Vector3 = garage_side["direction"]
	# The shift starts loading at the garage stop.
	spawn_player(garage_side["stop_point"], Basis.looking_at(dir, Vector3.UP))
	traffic = Traffic.new()
	traffic.name = "Traffic"
	add_child(traffic)
	traffic.populate(layout, 56, player.global_position)
	traffic.park_vehicles(layout, 26)
	_spawn_hawkers()
	for i in stops.size():
		_spawn_waiting(i, rng.randi_range(2, 4))
	_add_roadside_people()
	_marker = _make_marker()
	add_child(_marker)
	if autopilot:
		_autopilot_ai = BusAI.new()
		_autopilot_ai.lane_offset = 3.2
		_autopilot_ai.max_speed = 13.0
		player.driver = _autopilot_ai
	_subtitle("Conductor: %s! %s! Enter with your change!" % [stops[0], stops[1]], 3.5)


func city_options() -> Dictionary:
	return {"mode": "work"}


## Hawkers with goods on their heads, walking the kerbs.
func _spawn_hawkers() -> void:
	for i in 14:
		var stop: Dictionary = layout.stops[rng.randi() % layout.stops.size()]
		var side: Dictionary = stop["sides"][rng.randi() % 2]
		var dir: Vector3 = side["direction"]
		var start: Vector3 = side["wait_point"] + Vector3(0, 0.15, 0) - RoadGraph.right_of(dir) * 1.6
		var h := Pedestrian.create(rng.randi())
		h.carries_load = true
		add_child(h)
		h.global_position = start + dir * rng.randf_range(-20.0, 20.0)
		h.patrol(start - dir * 30.0, start + dir * 30.0)


func is_servicing() -> bool:
	return not service.is_empty()


func leave_label() -> String:
	return "End shift"


func leave_from_pause() -> void:
	if manifest.journeys_completed == 0:
		exited.emit()
		return
	_finish_shift(false)


func mode_physics(delta: float) -> void:
	_demand_timer += delta
	if _demand_timer > 30.0:
		_demand_timer = 0.0
		var i := rng.randi() % stops.size()
		if manifest.waiting_at(stops[i]).size() < MAX_WAITING:
			_spawn_waiting(i, rng.randi_range(1, 2))
	if service.is_empty():
		_try_start_service()
	else:
		_update_service(delta)
	if _autopilot_ai:
		_autopilot_ai.hold = not service.is_empty()
	_check_stuck_at_target(delta)
	_guide_timer -= delta
	if _guide_timer <= 0.0:
		_guide_timer = 1.0
		_update_target()
	_update_guidance()
	_maybe_call_owa()
	hud.set_info("Seats %d/%d   Journeys %d/%d   Fares %s" % [
		manifest.occupied_seats(), manifest.capacity, manifest.journeys_completed,
		int(route["journeys_target"]), UiKit.money(manifest.fares_total)])
	if service.is_empty() and manifest.journeys_completed >= int(route["journeys_target"]):
		_finish_shift(true)


## Stopped near the target stop but service cannot start (wrong angle, or
## nobody to serve on this kerb): give the stop a rest and pick again.
func _check_stuck_at_target(delta: float) -> void:
	if not service.is_empty() or target_stop == "" or absf(player.speed) > 0.5:
		_idle_at_target = 0.0
		return
	if player.global_position.distance_to(_target_point) > SERVICE_RADIUS + 3.0:
		_idle_at_target = 0.0
		return
	_idle_at_target += delta
	if _idle_at_target > STUCK_AT_STOP:
		_idle_at_target = 0.0
		_served_at[target_stop] = elapsed
		if manifest.riders_for(target_stop).is_empty():
			target_stop = ""
		_target_key = ""
		_guide_timer = 0.0


func _finish_shift(completed: bool) -> void:
	finish({
		"mode": "work", "route_id": route_id, "qualifying": completed,
		"fares": manifest.fares_total, "journeys": manifest.journeys_completed,
	})


# --- Passengers -------------------------------------------------------------

func _spawn_waiting(stop_index: int, count: int) -> void:
	var stop_name := stops[stop_index]
	for k in count:
		var ahead := rng.randi_range(1, 3)
		var dest := stops[(stop_index + ahead) % stops.size()]
		var pid := manifest.add_waiting(stop_name, dest, ahead)
		var kerb := rng.randi() % 2
		kerb_of[pid] = kerb
		var fig := Pedestrian.create(pid * 7 + 3)
		add_child(fig)
		fig.global_position = _wait_spot(layout.stops_by_name[stop_name]["sides"][kerb])
		figures[pid] = fig


## Waiting passengers at a stop on one kerb (they board from that side only).
func _waiting_on(stop_name: String, kerb: int) -> Array[int]:
	var result: Array[int] = []
	for pid in manifest.waiting_at(stop_name):
		if kerb_of.get(pid, 0) == kerb:
			result.append(pid)
	return result


func _side_index(stop_name: String, side: Dictionary) -> int:
	return layout.stops_by_name[stop_name]["sides"].find(side)


func _wait_spot(side: Dictionary) -> Vector3:
	var dir: Vector3 = side["direction"]
	var right := RoadGraph.right_of(dir)
	return side["wait_point"] + dir * rng.randf_range(-3.5, 3.5) + right * rng.randf_range(0.0, 1.0) + Vector3(0, 0.15, 0)


func _add_roadside_people() -> void:
	for stop in layout.stops:
		if rng.randf() < 0.5:
			continue
		var side: Dictionary = stop["sides"][1]
		for k in rng.randi_range(1, 3):
			var fig := Pedestrian.create(rng.randi())
			add_child(fig)
			fig.global_position = _wait_spot(side)
			fig.rotation.y = rng.randf() * TAU


# --- Stop service ------------------------------------------------------------

func _try_start_service() -> void:
	if absf(player.speed) > 0.8:
		return
	for stop_name in stops:
		var stop: Dictionary = layout.stops_by_name[stop_name]
		for side in stop["sides"]:
			if player.global_position.distance_to(side["stop_point"]) > SERVICE_RADIUS:
				continue
			if player.forward_vector().dot(side["direction"]) < ALIGN_DOT:
				continue
			var alight := manifest.riders_for(stop_name)
			var kerb := _side_index(stop_name, side)
			var can_board := manifest.free_seats() + alight.size() > 0 and not _waiting_on(stop_name, kerb).is_empty()
			if alight.is_empty() and not can_board:
				continue
			service = {"stop": stop_name, "side": side, "kerb": kerb, "alight": alight, "phase": "door", "timer": 0.5, "boarding": -1}
			player.visual.set_door_open(true)
			hud.set_banner(stop_name)
			if can_board:
				_subtitle("Conductor: %s! Enter with your change!" % _next_call(stop_name), 2.5)
			return


func _update_service(delta: float) -> void:
	if absf(player.speed) > 1.2:
		_abort_service()
		return
	service["timer"] = float(service["timer"]) - delta
	var boarding: int = service["boarding"]
	if boarding != -1:
		var fig: Pedestrian = figures.get(boarding)
		if fig == null or not fig.is_walking() or float(service["timer"]) <= 0.0:
			_complete_boarding(boarding)
		return
	if float(service["timer"]) > 0.0:
		return
	match service["phase"]:
		"door":
			service["phase"] = "alight"
		"alight":
			var queue: Array = service["alight"]
			if queue.is_empty():
				service["phase"] = "board"
			else:
				_alight_one(queue.pop_front())
				service["timer"] = ALIGHT_STEP
		"board":
			var waiting := _waiting_on(service["stop"], service["kerb"])
			if waiting.is_empty() or manifest.free_seats() == 0:
				service["phase"] = "close"
				service["timer"] = 0.5
				player.visual.set_door_open(false)
			else:
				_begin_boarding(waiting[0])
		"close":
			_served_at[service["stop"]] = elapsed
			service = {}
			hud.set_banner("")
			_guide_timer = 0.0
			_target_key = ""
			target_stop = ""


func _alight_one(pid: int) -> void:
	var seat := int(manifest.passengers[pid]["seat"])
	manifest.begin_alight(pid)
	var fare := manifest.complete_alight(pid)
	player.visual.set_passenger_seat(seat, false, 0)
	player.set_passenger_count(manifest.occupied_seats())
	var fig := Pedestrian.create(pid * 7 + 3)
	add_child(fig)
	fig.global_position = player.door_point() + Vector3(0, 0.15, 0)
	fig.walk_to(_wait_spot(service["side"]), 1.4)
	fig.arrived.connect(fig.queue_free)
	if fare > 0:
		hud.show_toast("+%s  fare collected" % UiKit.money(fare), 1.5)


func _begin_boarding(pid: int) -> void:
	if manifest.reserve_seat(pid) < 0:
		return
	service["boarding"] = pid
	service["timer"] = BOARD_TIMEOUT
	var fig: Pedestrian = figures.get(pid)
	if fig:
		fig.walk_to(player.door_point() + Vector3(0, 0.15, 0), 2.4)


func _complete_boarding(pid: int) -> void:
	if manifest.complete_boarding(pid):
		var seat := int(manifest.passengers[pid]["seat"])
		player.visual.set_passenger_seat(seat, true, pid * 7 + 3)
		player.set_passenger_count(manifest.occupied_seats())
	var fig: Pedestrian = figures.get(pid)
	if fig:
		fig.queue_free()
	figures.erase(pid)
	service["boarding"] = -1
	service["timer"] = 0.15


## Driving off mid-service: anyone not yet aboard goes back to wait; nobody is
## charged twice and no seat stays reserved.
func _abort_service() -> void:
	var pid: int = service["boarding"]
	if pid != -1:
		manifest.cancel_boarding(pid)
		var fig: Pedestrian = figures.get(pid)
		if fig:
			fig.walk_to(_wait_spot(service["side"]), 1.4)
	player.visual.set_door_open(false)
	service = {}
	hud.set_banner("")
	_target_key = ""


func _next_call(stop_name: String) -> String:
	var i := stops.find(stop_name)
	return stops[(i + 1) % stops.size()]


# --- Guidance ----------------------------------------------------------------

func _update_target() -> void:
	if not service.is_empty():
		return
	var candidates: Array[String] = manifest.riding_destinations()
	if manifest.free_seats() > 0:
		for stop_name in stops:
			# A danfo loads and moves on: a stop just served waits its turn.
			if elapsed - float(_served_at.get(stop_name, -999.0)) < 45.0:
				continue
			if not manifest.waiting_at(stop_name).is_empty() and not candidates.has(stop_name):
				candidates.append(stop_name)
	if candidates.is_empty():
		_spawn_waiting(rng.randi() % stops.size(), 2)
		return
	# Keep the chosen stop while it is still wanted; only the route to it
	# (and which kerb to use) is re-planned as the player drives.
	if candidates.has(target_stop):
		candidates = [target_stop]
	var ahead := player.global_position + player.forward_vector() * 20.0
	var start := layout.graph.nearest_node(ahead)
	var best := INF
	var best_points := PackedVector3Array()
	var best_key := ""
	var best_stop := ""
	var best_point := Vector3.ZERO
	var best_side := {}
	var dropoffs := manifest.riding_destinations()
	for stop_name in candidates:
		var stop: Dictionary = layout.stops_by_name[stop_name]
		for i in 2:
			var side: Dictionary = stop["sides"][i]
			var dropoff := dropoffs.has(stop_name)
			if not dropoff and _waiting_on(stop_name, i).is_empty():
				continue
			var pts := _approach(side, start)
			var cost := _length(player.global_position, pts)
			if not dropoff:
				cost *= 1.4 # people getting down come first
			if cost < best:
				best = cost
				best_points = pts
				best_key = "%s:%d" % [stop_name, i]
				best_stop = stop_name
				best_point = side["stop_point"]
				best_side = side
	if best_stop == "":
		return
	target_stop = best_stop
	guide_points = best_points
	_target_point = best_point
	_marker.global_position = best_point + Vector3(0, 0.04, 0)
	var side_dir: Vector3 = layout.stops_by_name[best_stop]["sides"][int(best_key.get_slice(":", 1))]["direction"]
	_marker.global_transform.basis = Basis.looking_at(side_dir, Vector3.UP)
	if autopilot and best_stop != _target_key.get_slice(":", 0):
		_autopilot_ai.set_path(BusAI.densify(_centre_route(best_points, best_side), false, 3.0), false, player.global_position)
		_autopilot_ai.stop_point = best_point
	_target_key = best_key


func _update_guidance() -> void:
	if guide_points.is_empty():
		hud.set_guidance(player, null)
		return
	var pos := player.global_position
	var aim := guide_points[guide_points.size() - 1]
	for p in guide_points:
		if p.distance_to(pos) > 14.0 and (p - pos).dot(player.forward_vector()) > -4.0:
			aim = p
			break
	var remaining := pos.distance_to(_target_point)
	hud.set_guidance(player, aim, "%s · %d m" % [target_stop, int(remaining)])


func _maybe_call_owa() -> void:
	if target_stop == "" or target_stop == _owa_called:
		return
	if manifest.riders_for(target_stop).is_empty():
		return
	if player.global_position.distance_to(_target_point) < 90.0:
		_owa_called = target_stop
		_subtitle("Passenger: O wa o! %s!" % target_stop, 2.5)


func _subtitle(text: String, seconds: float) -> void:
	if GameState.pref("subtitles"):
		hud.show_toast(text, seconds)


## Route to a stop side ending at its stop point. When the bus is already on
## that road, heading the side's way and short of the stop, go straight there.
func _approach(side: Dictionary, start: int) -> PackedVector3Array:
	var pos := player.global_position
	var dir: Vector3 = side["direction"]
	var a := layout.graph.node_position(side["from_node"])
	var b := layout.graph.node_position(side["to_node"])
	var along := (pos - a).dot(dir)
	var lateral := absf((pos - a).dot(RoadGraph.right_of(dir)))
	var to_stop: float = (side["stop_point"] - pos).dot(dir)
	if lateral < DistrictLayout.ROAD_WIDTH and along > -6.0 and along < a.distance_to(b) and to_stop > -3.0 \
			and player.forward_vector().dot(dir) > 0.5:
		return PackedVector3Array([side["stop_point"]])
	var pts := layout.graph.path_points(start, side["from_node"])
	pts.append(side["stop_point"])
	return pts


## Road-centre version of a route for the autopilot (its lane offset puts it
## in the kerbside lane): junctions, then the middle of the stop's road.
func _centre_route(route: PackedVector3Array, side: Dictionary) -> PackedVector3Array:
	var a := layout.graph.node_position(side["from_node"])
	var b := layout.graph.node_position(side["to_node"])
	var dir: Vector3 = side["direction"]
	var pts := PackedVector3Array()
	if route.size() == 1:
		pts.append(a + dir * maxf((player.global_position - a).dot(dir), 0.0))
	else:
		for i in route.size() - 1:
			pts.append(route[i])
	pts.append((a + b) * 0.5)
	pts.append((a + b) * 0.5 + dir * 6.0)
	return pts


static func _length(from: Vector3, pts: PackedVector3Array) -> float:
	var total := 0.0
	var prev := from
	for p in pts:
		total += prev.distance_to(p)
		prev = p
	return total


func _make_marker() -> MeshInstance3D:
	var plane := PlaneMesh.new()
	plane.size = Vector2(3.0, 7.0)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(1.0, 0.82, 0.1, 0.28)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	var mi := MeshInstance3D.new()
	mi.mesh = plane
	mi.material_override = mat
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return mi
