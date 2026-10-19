class_name RaceTracker
extends RefCounted
## Distance-along-course progress for every racer on a closed loop, with
## continuity checks so a racer cannot skip ahead, plus standings.

const SEARCH_WINDOW := 70.0

var points := PackedVector3Array()
var cumulative := PackedFloat32Array()
var length := 0.0
var laps := 1
var racers := {} # id -> {total, finished, finish_time}


func setup(loop_points: PackedVector3Array, lap_count: int) -> void:
	points = loop_points
	laps = lap_count
	cumulative.resize(points.size() + 1)
	cumulative[0] = 0.0
	for i in points.size():
		var a := points[i]
		var b := points[(i + 1) % points.size()]
		cumulative[i + 1] = cumulative[i] + a.distance_to(b)
	length = cumulative[points.size()]


func race_distance() -> float:
	return length * laps


## Registers a racer standing on the grid; positions just behind the start
## line count as small negative progress.
func register(id: Variant, pos: Vector3) -> void:
	var d := project(pos)
	var total := d if d < length * 0.5 else d - length
	racers[id] = {"total": total, "finished": false, "finish_time": 0.0}


## Distance along the loop of the closest point to `pos`, in [0, length).
func project(pos: Vector3) -> float:
	var best := INF
	var best_d := 0.0
	for i in points.size():
		var a := points[i]
		var b := points[(i + 1) % points.size()]
		var ab := b - a
		var t := clampf((pos - a).dot(ab) / ab.length_squared(), 0.0, 1.0)
		var dist := pos.distance_squared_to(a + ab * t)
		if dist < best:
			best = dist
			best_d = cumulative[i] + ab.length() * t
	return fposmod(best_d, length)


## Updates progress from a new position. Moves larger than the search window
## (a shortcut or teleport) are ignored. Returns true when the racer finishes.
func update(id: Variant, pos: Vector3, race_time: float) -> bool:
	var r: Dictionary = racers[id]
	if r["finished"]:
		return false
	var local := fposmod(float(r["total"]), length)
	var delta := project(pos) - local
	if delta > length * 0.5:
		delta -= length
	elif delta < -length * 0.5:
		delta += length
	if absf(delta) > SEARCH_WINDOW:
		return false
	r["total"] = float(r["total"]) + delta
	if r["total"] >= race_distance():
		r["finished"] = true
		r["finish_time"] = race_time
		return true
	return false


func lap_of(id: Variant) -> int:
	return clampi(int(floor(maxf(float(racers[id]["total"]), 0.0) / length)) + 1, 1, laps)


## Racer ids ordered: finishers by time, then everyone else by progress.
func standings() -> Array:
	var ids := racers.keys()
	ids.sort_custom(func(a, b):
		var ra: Dictionary = racers[a]
		var rb: Dictionary = racers[b]
		if ra["finished"] != rb["finished"]:
			return ra["finished"]
		if ra["finished"]:
			return ra["finish_time"] < rb["finish_time"]
		return ra["total"] > rb["total"])
	return ids


func position_of(id: Variant) -> int:
	return standings().find(id) + 1
