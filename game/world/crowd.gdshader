shader_type spatial;
// Instanced crowd figures. Vertex alpha picks the part: 1 = clothes (per
// instance custom rgb), 0 = skin (per instance custom alpha), 0.5 = the
// vertex colour itself (head loads, trousers). Each figure sways a little.

varying vec3 clothes;
varying float skin_t;

void vertex() {
	clothes = INSTANCE_CUSTOM.rgb;
	skin_t = INSTANCE_CUSTOM.a;
	float phase = float(INSTANCE_ID) * 1.731;
	float lean = VERTEX.y * 0.03;
	VERTEX.x += sin(TIME * 1.1 + phase) * lean;
	VERTEX.z += cos(TIME * 0.83 + phase * 1.3) * lean;
}

void fragment() {
	vec3 skin = mix(vec3(0.17, 0.1, 0.06), vec3(0.42, 0.27, 0.17), skin_t);
	vec3 c = COLOR.a > 0.75 ? clothes : (COLOR.a < 0.25 ? skin : COLOR.rgb);
	ALBEDO = c;
	ROUGHNESS = 0.92;
}
