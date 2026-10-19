class_name EnvironmentBuilder
extends RefCounted
## Hazy tropical daylight: procedural sky, warm sun, light haze. No dynamic
## shadows on the low tier; vehicles use blob shadows instead.


static func add_to(parent: Node) -> void:
	var sky_mat := ProceduralSkyMaterial.new()
	# Hazy, dust-whitened sky; the horizon goes warm grey-yellow.
	sky_mat.sky_top_color = Color(0.48, 0.6, 0.76)
	sky_mat.sky_horizon_color = Color(0.86, 0.82, 0.72)
	sky_mat.ground_horizon_color = Color(0.72, 0.64, 0.54)
	sky_mat.ground_bottom_color = Color(0.42, 0.32, 0.24)
	var sky := Sky.new()
	sky.sky_material = sky_mat
	var env := Environment.new()
	env.background_mode = Environment.BG_SKY
	env.sky = sky
	env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	env.ambient_light_energy = 0.85
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.tonemap_white = 1.2
	env.fog_enabled = true
	env.fog_light_color = Color(0.84, 0.78, 0.66)
	env.fog_density = 0.0042
	env.fog_sky_affect = 0.55
	# Slightly bleached, warm colour grade.
	env.adjustment_enabled = true
	env.adjustment_saturation = 0.86
	env.adjustment_contrast = 1.06
	var world_env := WorldEnvironment.new()
	world_env.environment = env
	parent.add_child(world_env)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-52, -35, 0)
	sun.light_color = Color(1.0, 0.92, 0.8)
	sun.light_energy = 1.25
	sun.shadow_enabled = false
	parent.add_child(sun)
