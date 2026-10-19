class_name Ambience
extends Node
## Background of the street: crowd murmur and generators, with horns going off
## around the player at random, near and far.

var _bed: AudioStreamPlayer
var _horn_timer := 1.5
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()
	_bed = AudioStreamPlayer.new()
	_bed.stream = Synth.street_loop()
	_bed.volume_db = -14.0
	add_child(_bed)
	_bed.play()


func _process(delta: float) -> void:
	_horn_timer -= delta
	if _horn_timer > 0.0:
		return
	_horn_timer = _rng.randf_range(0.8, 4.0)
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return
	var horn := AudioStreamPlayer3D.new()
	var ids := Content.HORNS.keys()
	horn.stream = Synth.horn(ids[_rng.randi() % ids.size()])
	horn.pitch_scale = _rng.randf_range(0.85, 1.2)
	horn.unit_size = 10.0
	horn.volume_db = _rng.randf_range(-12.0, -2.0)
	add_child(horn)
	var angle := _rng.randf() * TAU
	horn.global_position = camera.global_position + Vector3(cos(angle), 0, sin(angle)) * _rng.randf_range(15.0, 70.0)
	horn.finished.connect(horn.queue_free)
	horn.play()
