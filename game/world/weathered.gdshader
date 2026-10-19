shader_type spatial;
// Weathering for vertex-coloured geometry: blotchy grime, rain streaks and a
// dusty splash zone on walls, laterite dust settling on top faces. Static
// world geometry samples world space; vehicles use model space so the dirt
// moves with them.

uniform sampler2D noise_tex : hint_default_white, repeat_enable, filter_linear_mipmap;
uniform bool local_space = false;
uniform float grime_strength : hint_range(0.0, 1.0) = 0.45;
uniform float streak_strength : hint_range(0.0, 1.0) = 0.3;
uniform float dust_strength : hint_range(0.0, 1.0) = 0.35;
uniform vec3 dust_color : source_color = vec3(0.66, 0.47, 0.33);
uniform float roughness_value = 0.92;

varying vec3 v_pos;
varying vec3 v_normal;

void vertex() {
	if (local_space) {
		v_pos = VERTEX;
		v_normal = NORMAL;
	} else {
		v_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
		v_normal = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
	}
}

void fragment() {
	vec3 base = COLOR.rgb;
	vec3 n = abs(v_normal);
	bool top = n.y > 0.6;
	vec2 uv = top ? v_pos.xz : (n.x > n.z ? v_pos.zy : v_pos.xy);
	float big = texture(noise_tex, uv * 0.06).r;
	float fine = texture(noise_tex, uv * 0.42 + vec2(0.37, 0.11)).r;
	float grime = smoothstep(0.38, 0.86, big * 0.6 + fine * 0.4);
	vec3 dirty = base * vec3(0.52, 0.5, 0.46);
	vec3 col = mix(base, dirty, grime * grime_strength);
	if (!top) {
		// Vertical rain streaks and a splash/dust band near the ground.
		float streak = texture(noise_tex, vec2(uv.x * 0.9, v_pos.y * 0.04)).r;
		col *= 1.0 - streak_strength * smoothstep(0.55, 0.92, streak);
		float splash = 1.0 - smoothstep(0.1, 1.4, v_pos.y);
		col = mix(col, dust_color * 0.75, splash * dust_strength);
	} else {
		col = mix(col, dust_color, dust_strength * smoothstep(0.35, 0.8, fine) * 0.7);
	}
	ALBEDO = col;
	ROUGHNESS = roughness_value;
}
