class_name DistrictLayout
extends RefCounted
## Data for the Phase 0 test district: a connected grid of roads, city blocks,
## named stops on both kerbs, and the two race loops. Pure data, so tests can
## check connectivity and reachability without building any scene.

const GRID := 5 # junctions per side
const SPACING := 110.0 # metres between junctions
const ROAD_WIDTH := 12.0
const SIDEWALK := 3.0
const STOP_LANE_OFFSET := 4.0 # kerbside lane centre, from road centre
const WAIT_OFFSET := ROAD_WIDTH * 0.5 + 1.4 # waiting patch on the pavement

var graph := RoadGraph.new()
var stops: Array[Dictionary] = []
var stops_by_name := {}
var blocks: Array[Dictionary] = []
var loops := {}
var rng := RandomNumberGenerator.new()

# Directed edges (from junction, to junction) in grid coordinates for each
# named stop. Chosen so the route stops spread across the district.
const STOP_EDGES := {
	"Garage": [Vector2i(1, 2), Vector2i(1, 1)],
	"Market Junction": [Vector2i(1, 1), Vector2i(2, 1)],
	"Filling Station": [Vector2i(3, 1), Vector2i(3, 2)],
	"Under Bridge": [Vector2i(3, 3), Vector2i(2, 3)],
	"Church Gate": [Vector2i(2, 3), Vector2i(1, 3)],
	"Mechanic Village": [Vector2i(0, 3), Vector2i(0, 2)],
	"Mosque Road": [Vector2i(0, 0), Vector2i(1, 0)],
	"School Road": [Vector2i(2, 0), Vector2i(3, 0)],
	"Pharmacy": [Vector2i(4, 0), Vector2i(4, 1)],
	"Big Tree": [Vector2i(4, 2), Vector2i(4, 3)],
	"Water Tank": [Vector2i(4, 4), Vector2i(3, 4)],
	"Old Cinema": [Vector2i(2, 4), Vector2i(1, 4)],
	"Hospital Gate": [Vector2i(2, 1), Vector2i(2, 2)],
	"Bank Corner": [Vector2i(2, 2), Vector2i(3, 2)],
	"Plank Market": [Vector2i(0, 1), Vector2i(0, 0)],
	"Second Gate": [Vector2i(1, 3), Vector2i(1, 4)],
}


func generate(seed := 7) -> void:
	rng.seed = seed
	for iz in GRID:
		for ix in GRID:
			graph.add_node(node_id(ix, iz), node_pos(ix, iz))
	for iz in GRID:
		for ix in GRID:
			if ix + 1 < GRID:
				graph.connect_nodes(node_id(ix, iz), node_id(ix + 1, iz))
			if iz + 1 < GRID:
				graph.connect_nodes(node_id(ix, iz), node_id(ix, iz + 1))
	_build_blocks()
	_build_stops()
	_build_loops()


static func node_id(ix: int, iz: int) -> int:
	return iz * GRID + ix


static func node_pos(ix: int, iz: int) -> Vector3:
	var half := (GRID - 1) * 0.5
	return Vector3((ix - half) * SPACING, 0.0, (iz - half) * SPACING)


func half_extent() -> float:
	return (GRID - 1) * 0.5 * SPACING


func _build_blocks() -> void:
	var size := SPACING - ROAD_WIDTH
	for iz in GRID - 1:
		for ix in GRID - 1:
			var center := (node_pos(ix, iz) + node_pos(ix + 1, iz + 1)) * 0.5
			var kind := "buildings"
			if ix == 0 and iz == 1:
				kind = "garage"
			elif ix == 1 and iz == 0:
				kind = "market"
			blocks.append({"center": center, "size": size, "kind": kind, "seed": rng.randi()})


func _build_stops() -> void:
	for stop_name in STOP_EDGES:
		var pair: Array = STOP_EDGES[stop_name]
		var a := node_id(pair[0].x, pair[0].y)
		var b := node_id(pair[1].x, pair[1].y)
		assert(graph.has_edge(a, b), "Stop edge must be a road: %s" % stop_name)
		var pa := graph.node_position(a)
		var pb := graph.node_position(b)
		var mid := (pa + pb) * 0.5
		var dir := (pb - pa).normalized()
		var sides: Array[Dictionary] = []
		for travel in [dir, -dir]:
			var right := RoadGraph.right_of(travel)
			sides.append({
				"direction": travel,
				"stop_point": mid + right * STOP_LANE_OFFSET,
				"wait_point": mid + right * WAIT_OFFSET,
				"from_node": a if travel == dir else b,
				"to_node": b if travel == dir else a,
			})
		var stop := {"name": stop_name, "a": a, "b": b, "center": mid, "sides": sides}
		stops.append(stop)
		stops_by_name[stop_name] = stop


func _build_loops() -> void:
	var outer := PackedInt64Array()
	for ix in GRID:
		outer.append(node_id(ix, 0))
	for iz in range(1, GRID):
		outer.append(node_id(GRID - 1, iz))
	for ix in range(GRID - 2, -1, -1):
		outer.append(node_id(ix, GRID - 1))
	for iz in range(GRID - 2, 0, -1):
		outer.append(node_id(0, iz))
	loops["outer"] = outer
	var inner := PackedInt64Array()
	for ix in range(1, GRID - 1):
		inner.append(node_id(ix, 1))
	for iz in range(2, GRID - 1):
		inner.append(node_id(GRID - 2, iz))
	for ix in range(GRID - 3, 0, -1):
		inner.append(node_id(ix, GRID - 2))
	for iz in range(GRID - 3, 1, -1):
		inner.append(node_id(1, iz))
	loops["inner"] = inner


## Closed loop of road-centre points for a race loop, starting at its first node.
func loop_points(loop_name: String) -> PackedVector3Array:
	var points := PackedVector3Array()
	for id in loops[loop_name]:
		points.append(graph.node_position(id))
	return points


## The same loop, but starting halfway along its first road so a race grid
## can sit on a straight rather than at a junction.
func loop_points_from_mid(loop_name: String) -> PackedVector3Array:
	var corners := loop_points(loop_name)
	var points := PackedVector3Array([(corners[0] + corners[1]) * 0.5])
	for i in range(1, corners.size()):
		points.append(corners[i])
	points.append(corners[0])
	return points


## True when every consecutive pair in the loop (including the wrap) is a road.
func loop_is_valid(loop_name: String) -> bool:
	var ids: PackedInt64Array = loops[loop_name]
	for i in ids.size():
		if not graph.has_edge(ids[i], ids[(i + 1) % ids.size()]):
			return false
	return ids.size() >= 3
