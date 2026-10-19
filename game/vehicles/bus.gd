class_name Bus
extends RigidBody3D
## Project-owned danfo controller on a Jolt rigid body: four raycast wheels with
## spring/damper suspension, a friction-circle tyre model with simple grip
## curves, rear-wheel drive, speed-sensitive steering for touch, anti-roll and
## upright recovery. Inputs come from `driver` (player input or AI) every tick.

## Bump when handling changes, so stored personal records stay comparable.
const PHYSICS_VERSION := 1

const LAYER_WORLD := 1
const LAYER_VEHICLES := 2

@export var model_id := "classic14"
@export var base_mass := 2050.0 # empty bus with driver and conductor
@export var passenger_mass := 70.0
@export var wheel_radius := 0.34
@export var suspension_travel := 0.32
@export var spring_rate := 52000.0
@export var damping := 4600.0
@export var anti_roll := 26000.0
@export var drive_force := 9200.0
@export var brake_force := 8200.0
@export var reverse_force := 4200.0
@export var top_speed := 27.0 # m/s, about 97 km/h
@export var grip := 1.05
@export var slip_saturation := 1.6 # m/s of sideways slip at peak grip
@export var max_steer_low := deg_to_rad(34.0)
@export var max_steer_high := deg_to_rad(7.0)
@export var steer_rate := 2.8 # rad/s

## Object with `drive_input(bus: Bus) -> Dictionary` returning throttle, brake, steer.
var driver: Object = null
var controls_locked := false

var throttle := 0.0
var brake := 0.0
var steer_input := 0.0
var steer_angle := 0.0
var speed := 0.0 # signed forward speed, m/s
var distance_travelled := 0.0
var grounded_wheels := 0

var wheel_mounts: Array[Vector3] = []
var wheel_compression: Array[float] = [0.0, 0.0, 0.0, 0.0]
var wheel_spin: Array[float] = [0.0, 0.0, 0.0, 0.0]
var _upside_down_time := 0.0
var _recover_point := Vector3.ZERO
var _recover_basis := Basis.IDENTITY
var _has_recover_point := false

@onready var visual: BusVisual = $Visual


## Builds a bus with its collision box and procedural body, ready to add.
static func create(model := "classic14", paint := "lagos_yellow", slogan := "") -> Bus:
	var bus := Bus.new()
	bus.model_id = model
	var dims: Dictionary = Content.BUS_MODELS[model]
	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(float(dims["width"]) - 0.02, BusVisual.ROOF_Y - BusVisual.FLOOR_Y, float(dims["length"]))
	shape.shape = box
	shape.position = Vector3(0, (BusVisual.ROOF_Y + BusVisual.FLOOR_Y) * 0.5, 0)
	bus.add_child(shape)
	var vis := BusVisual.new()
	vis.name = "Visual"
	bus.add_child(vis)
	vis.build(model, paint, slogan)
	return bus


func _ready() -> void:
	var dims: Dictionary = Content.BUS_MODELS[model_id]
	var half_track := float(dims["width"]) * 0.5 - 0.14
	var half_base := float(dims["wheelbase"]) * 0.5
	# Front wheels first (index 0 left, 1 right), then rear. Godot forward is -Z.
	wheel_mounts = [
		Vector3(-half_track, 0.05, -half_base), Vector3(half_track, 0.05, -half_base),
		Vector3(-half_track, 0.05, half_base), Vector3(half_track, 0.05, half_base),
	]
	mass = base_mass
	center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
	center_of_mass = Vector3(0.0, 0.3, 0.15) # low, slightly rearward (rear engine)
	collision_layer = LAYER_VEHICLES
	collision_mask = LAYER_WORLD | LAYER_VEHICLES
	can_sleep = false
	continuous_cd = false
	# Drag and rolling resistance are modelled explicitly, so replace Godot's
	# default damping instead of adding to it.
	linear_damp_mode = RigidBody3D.DAMP_MODE_REPLACE
	linear_damp = 0.0
	angular_damp_mode = RigidBody3D.DAMP_MODE_REPLACE
	angular_damp = 0.5
	var mat := PhysicsMaterial.new()
	mat.friction = 0.35 # low body friction: buses scrape past instead of sticking
	mat.bounce = 0.05
	physics_material_override = mat


var _engine_audio: AudioStreamPlayer3D
var _horn_audio: AudioStreamPlayer3D


func enable_audio(horn_id: String, with_engine: bool) -> void:
	_horn_audio = AudioStreamPlayer3D.new()
	_horn_audio.stream = Synth.horn(horn_id)
	_horn_audio.unit_size = 12.0
	_horn_audio.volume_db = -2.0
	add_child(_horn_audio)
	if with_engine:
		_engine_audio = AudioStreamPlayer3D.new()
		_engine_audio.stream = Synth.engine_loop()
		_engine_audio.unit_size = 8.0
		_engine_audio.volume_db = -10.0
		add_child(_engine_audio)
		_engine_audio.play()


func play_horn() -> void:
	if _horn_audio and not _horn_audio.playing:
		_horn_audio.play()


func set_passenger_count(count: int) -> void:
	mass = base_mass + passenger_mass * count


func set_racing(enabled: bool) -> void:
	continuous_cd = enabled


func kmh() -> float:
	return absf(speed) * 3.6


func forward_vector() -> Vector3:
	return -global_transform.basis.z


func _physics_process(delta: float) -> void:
	var input := {"throttle": 0.0, "brake": 0.0, "steer": 0.0}
	if driver != null and not controls_locked:
		input = driver.drive_input(self)
	throttle = clampf(float(input.get("throttle", 0.0)), 0.0, 1.0)
	brake = clampf(float(input.get("brake", 0.0)), 0.0, 1.0)
	steer_input = clampf(float(input.get("steer", 0.0)), -1.0, 1.0)
	var speed_t := clampf(absf(speed) / top_speed, 0.0, 1.0)
	var max_steer := lerpf(max_steer_low, max_steer_high, speed_t * speed_t * (3.0 - 2.0 * speed_t))
	steer_angle = move_toward(steer_angle, steer_input * max_steer, steer_rate * delta)
	distance_travelled += absf(speed) * delta
	_track_recovery(delta)
	if _engine_audio:
		_engine_audio.pitch_scale = 0.75 + clampf(absf(speed) / top_speed, 0.0, 1.0) * 1.1 + throttle * 0.15
	if visual:
		visual.update_wheels(self, delta)


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var xf := state.transform
	var bb := xf.basis
	var up := bb.y
	var space := state.get_space_state()
	var dt := state.step
	var corner_mass := mass * 0.25
	speed = state.linear_velocity.dot(-bb.z)
	grounded_wheels = 0

	var reversing := brake > 0.1 and throttle < 0.05 and speed < 1.0
	var drive := 0.0
	if reversing:
		drive = -brake * reverse_force * clampf(1.0 + speed / 6.0, 0.0, 1.0)
	elif throttle > 0.0:
		drive = throttle * drive_force * clampf(1.0 - speed / top_speed, 0.0, 1.0)

	for i in 4:
		var mount_world := xf * wheel_mounts[i]
		var ray_len := suspension_travel + wheel_radius
		var query := PhysicsRayQueryParameters3D.create(mount_world, mount_world - up * ray_len, LAYER_WORLD, [get_rid()])
		var hit := space.intersect_ray(query)
		if hit.is_empty():
			wheel_compression[i] = 0.0
			continue
		grounded_wheels += 1
		var dist: float = mount_world.distance_to(hit["position"])
		var compression := clampf(suspension_travel - (dist - wheel_radius), 0.0, suspension_travel)
		wheel_compression[i] = compression
		var contact: Vector3 = hit["position"]
		var normal: Vector3 = hit["normal"]
		var offset := contact - xf.origin
		var point_vel := state.linear_velocity + state.angular_velocity.cross(offset)

		var spring := spring_rate * compression - damping * point_vel.dot(up)
		var wheel_load := maxf(spring, 0.0)

		var is_front := i < 2
		var wheel_basis := bb
		if is_front:
			wheel_basis = bb.rotated(up, -steer_angle)
		var fwd := (-wheel_basis.z - normal * (-wheel_basis.z).dot(normal)).normalized()
		var right := fwd.cross(normal).normalized()
		var v_long := point_vel.dot(fwd)
		var v_lat := point_vel.dot(right)

		var max_force := grip * wheel_load
		var slip := v_lat / slip_saturation
		var lat_mu := clampf(slip, -1.0, 1.0)
		if absf(slip) > 1.0:
			lat_mu *= lerpf(1.0, 0.82, clampf(absf(slip) - 1.0, 0.0, 1.0))
		var f_lat := -lat_mu * max_force
		# At very low speed, cancel sideways creep directly so the bus can park.
		if absf(v_long) < 2.0:
			f_lat = clampf(-v_lat * corner_mass / dt * 0.5, -max_force, max_force)

		var f_long := 0.0
		if not is_front:
			f_long += drive * 0.5
		if brake > 0.0 and not reversing:
			var stop_force := -v_long * corner_mass / dt
			f_long += clampf(stop_force, -brake * brake_force * 0.25, brake * brake_force * 0.25)
		f_long -= v_long * 6.0 # rolling resistance

		var combined := Vector2(f_lat, f_long)
		if combined.length() > max_force and max_force > 0.0:
			combined = combined.normalized() * max_force
		var force := normal * wheel_load + right * combined.x + fwd * combined.y
		state.apply_force(force, offset)
		wheel_spin[i] = v_long / wheel_radius

	# Anti-roll bars on both axles.
	for axle in [[0, 1], [2, 3]]:
		var diff: float = wheel_compression[axle[0]] - wheel_compression[axle[1]]
		var roll_force := up * diff * anti_roll
		state.apply_force(roll_force, (xf * wheel_mounts[axle[0]]) - xf.origin)
		state.apply_force(-roll_force, (xf * wheel_mounts[axle[1]]) - xf.origin)

	# Aerodynamic drag.
	var v := state.linear_velocity
	state.apply_central_force(-v * v.length() * 0.95)

	# Contact stability: cap spin so hard hits stay recoverable.
	var max_spin := 3.5
	if state.angular_velocity.length() > max_spin:
		state.angular_velocity = state.angular_velocity.normalized() * max_spin


func _track_recovery(delta: float) -> void:
	var upright := global_transform.basis.y.dot(Vector3.UP)
	if grounded_wheels >= 3 and upright > 0.9:
		_recover_point = global_position
		_recover_basis = Basis(Vector3.UP, global_rotation.y)
		_has_recover_point = true
	if upright < 0.35:
		_upside_down_time += delta
		if _upside_down_time > 2.0:
			recover()
	else:
		_upside_down_time = 0.0


## Puts the bus back on its wheels at the last stable spot.
func recover() -> void:
	_upside_down_time = 0.0
	var target := _recover_point if _has_recover_point else global_position
	place_at(target, _recover_basis if _has_recover_point else Basis(Vector3.UP, global_rotation.y))


func place_at(pos: Vector3, facing: Basis) -> void:
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	global_transform = Transform3D(facing, pos + Vector3.UP * 0.6)
	reset_physics_interpolation()
	steer_angle = 0.0


## Ground-level point under the sliding door (right side, Nigeria drives right).
func door_point() -> Vector3:
	return global_transform * Vector3(1.25, -0.4, -0.25)
