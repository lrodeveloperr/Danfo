class_name RoadGraph
extends RefCounted
## Junctions and road segments. Used for navigation guidance, traffic lanes
## and race courses. Nigeria drives on the right.

var astar := AStar3D.new()
var positions := {} # int -> Vector3
var edges: Array[Vector2i] = []


func add_node(id: int, pos: Vector3) -> void:
	positions[id] = pos
	astar.add_point(id, pos)


func connect_nodes(a: int, b: int) -> void:
	if astar.are_points_connected(a, b):
		return
	astar.connect_points(a, b, true)
	edges.append(Vector2i(mini(a, b), maxi(a, b)))


func has_edge(a: int, b: int) -> bool:
	return astar.are_points_connected(a, b)


func neighbors(id: int) -> PackedInt64Array:
	return astar.get_point_connections(id)


func node_position(id: int) -> Vector3:
	return positions[id]


func nearest_node(pos: Vector3) -> int:
	return astar.get_closest_point(pos)


func path_ids(from_id: int, to_id: int) -> PackedInt64Array:
	return astar.get_id_path(from_id, to_id)


func path_points(from_id: int, to_id: int) -> PackedVector3Array:
	return astar.get_point_path(from_id, to_id)


func is_fully_connected() -> bool:
	if positions.is_empty():
		return true
	var start: int = positions.keys()[0]
	var seen := {start: true}
	var queue: Array[int] = [start]
	while not queue.is_empty():
		var id: int = queue.pop_back()
		for next in neighbors(id):
			if not seen.has(next):
				seen[next] = true
				queue.append(next)
	return seen.size() == positions.size()


## Unit vector to the right of a horizontal travel direction (Godot: -Z forward).
static func right_of(direction: Vector3) -> Vector3:
	var flat := Vector3(direction.x, 0.0, direction.z).normalized()
	return flat.cross(Vector3.UP)
