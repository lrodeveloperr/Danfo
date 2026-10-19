class_name Synth
extends RefCounted
## Procedurally generated, original audio: horns and an engine loop. Keeps the
## download small until recorded sound replaces it.

const RATE := 22050

static var _cache := {}


static func horn(horn_id: String) -> AudioStreamWAV:
	var key := "horn_" + horn_id
	if _cache.has(key):
		return _cache[key]
	var def: Dictionary = Content.HORNS.get(horn_id, Content.HORNS["two_tone"])
	var tones: Array = def["tones"]
	var pattern: Array = def["pattern"]
	var samples := PackedFloat32Array()
	var on := true
	for segment in pattern:
		var count := int(float(segment) * RATE)
		for i in count:
			var v := 0.0
			if on:
				var t := float(i) / RATE
				var env := minf(1.0, i / 220.0) * minf(1.0, float(count - i) / 300.0)
				for f in tones:
					v += tanh(sin(TAU * float(f) * t) * 2.5) * 0.3
				v *= env
			samples.append(v)
		on = not on
	var stream := _to_wav(samples, false)
	_cache[key] = stream
	return stream


## Half-second diesel-like loop; every partial completes whole cycles so the
## loop point is seamless. Pitch is raised with speed by the caller.
static func engine_loop() -> AudioStreamWAV:
	if _cache.has("engine"):
		return _cache["engine"]
	var count := RATE / 2
	var samples := PackedFloat32Array()
	samples.resize(count)
	var rng := RandomNumberGenerator.new()
	rng.seed = 11
	for i in count:
		var t := float(i) / RATE
		var v := 0.0
		v += sin(TAU * 48.0 * t) * 0.35
		v += sin(TAU * 96.0 * t + 0.6) * 0.22
		v += sin(TAU * 144.0 * t + 1.1) * 0.12
		v += sin(TAU * 24.0 * t) * 0.18 # firing pulse
		v += rng.randf_range(-1.0, 1.0) * 0.05
		samples[i] = tanh(v * 1.4) * 0.6
	var stream := _to_wav(samples, true)
	_cache["engine"] = stream
	return stream


static func _to_wav(samples: PackedFloat32Array, loop: bool) -> AudioStreamWAV:
	var bytes := PackedByteArray()
	bytes.resize(samples.size() * 2)
	for i in samples.size():
		bytes.encode_s16(i * 2, int(clampf(samples[i], -1.0, 1.0) * 32000.0))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = RATE
	stream.stereo = false
	stream.data = bytes
	if loop:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		stream.loop_begin = 0
		stream.loop_end = samples.size()
	return stream
