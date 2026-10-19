class_name ChaseCamera
extends Camera3D
## Follows a bus from behind using its interpolated transform, pulls in when a
## building would block the view, and widens slightly with speed unless the
## player has turned on reduced motion.

var target: Bus
var distance := 8.8
var height := 3.5
var look_ahead := 4.0
var reduced_motion := false
var _pos := Vector3.ZERO
var _yaw_dir := Vector3.FORWARD


func _ready() -> void:
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	fov = 62.0
	far = 600.0
	snap()


func snap() -> void:
	if target == null:
		return
	var t := target.global_transform
	_yaw_dir = _flat_forward(t)
	_pos = t.origin - _yaw_dir * distance + Vector3.UP * height
	global_position = _pos
	look_at(t.origin + _yaw_dir * look_ahead + Vector3.UP, Vector3.UP)


func _process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		return
	var t := target.get_global_transform_interpolated()
	var fwd := _flat_forward(t)
	# Reversing keeps the camera behind the bus's nose direction.
	_yaw_dir = _yaw_dir.slerp(fwd, 1.0 - exp(-delta * 3.0)).normalized()
	var desired := t.origin - _yaw_dir * distance + Vector3.UP * height
	var space := get_world_3d().direct_space_state
	var eye := t.origin + Vector3.UP * 1.6
	var query := PhysicsRayQueryParameters3D.create(eye, desired, Bus.LAYER_WORLD)
	var hit := space.intersect_ray(query)
	if not hit.is_empty():
		desired = hit["position"] + (eye - desired).normalized() * 0.6
	_pos = _pos.lerp(desired, 1.0 - exp(-delta * 6.0))
	global_position = _pos
	look_at(t.origin + _yaw_dir * look_ahead + Vector3.UP * 1.1, Vector3.UP)
	if not reduced_motion:
		fov = lerpf(fov, 62.0 + clampf(target.kmh() / 100.0, 0.0, 1.0) * 10.0, 1.0 - exp(-delta * 2.0))


static func _flat_forward(t: Transform3D) -> Vector3:
	var f := -t.basis.z
	f.y = 0.0
	return f.normalized() if f.length() > 0.01 else Vector3.FORWARD
