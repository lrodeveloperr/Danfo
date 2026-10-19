extends SceneTree
var work
var t := 0.0
func _initialize() -> void:
	work = load("res://modes/work_mode.gd").new()
	work.autopilot = true
	root.add_child(work)
func _physics_process(delta: float) -> bool:
	t += delta
	if int(t * 60) % 120 == 0:
		var p = work.player
		print("t=%3.0f pos=(%.0f,%.0f) kmh=%.0f tgt=%s key=%s svc=%s seats=%d j=%d ai_idx=%d/%d stop_d=%.1f" % [t, p.global_position.x, p.global_position.z, p.kmh(), work.target_stop, work._target_key, str(work.service.get("phase", "-")), work.manifest.occupied_seats(), work.manifest.journeys_completed, work._autopilot_ai._index, work._autopilot_ai.points.size(), p.global_position.distance_to(work._target_point)])
	return t > 90.0
