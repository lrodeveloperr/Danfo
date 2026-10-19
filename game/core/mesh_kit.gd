class_name MeshKit
extends RefCounted
## Builds merged, vertex-coloured box geometry so a whole bus body or city block
## is one draw call: the low-tier budget allows about 150 per frame.

static var _materials := {}


## Appends a box to `st` (begun with PRIMITIVE_TRIANGLES). Godot treats
## clockwise triangles as front-facing, which this winding follows.
static func box(st: SurfaceTool, center: Vector3, size: Vector3, color: Color, rot := Basis.IDENTITY) -> void:
	var half := size * 0.5
	for n in [Vector3.RIGHT, Vector3.LEFT, Vector3.UP, Vector3.DOWN, Vector3.BACK, Vector3.FORWARD]:
		var up_ref := Vector3.UP
		if n == Vector3.UP:
			up_ref = Vector3.FORWARD
		elif n == Vector3.DOWN:
			up_ref = Vector3.BACK
		var r: Vector3 = up_ref.cross(n)
		var hr: float = absf(r.x) * half.x + absf(r.y) * half.y + absf(r.z) * half.z
		var hu: float = absf(up_ref.x) * half.x + absf(up_ref.y) * half.y + absf(up_ref.z) * half.z
		var hn: float = absf(n.x) * half.x + absf(n.y) * half.y + absf(n.z) * half.z
		var fc: Vector3 = n * hn
		var tl: Vector3 = fc - r * hr + up_ref * hu
		var tr: Vector3 = fc + r * hr + up_ref * hu
		var br: Vector3 = fc + r * hr - up_ref * hu
		var bl: Vector3 = fc - r * hr - up_ref * hu
		var normal: Vector3 = rot * n
		st.set_color(color)
		st.set_normal(normal)
		for v in [tl, tr, br, tl, br, bl]:
			st.add_vertex(center + rot * v)


## Flat quad on the ground plane (normal up), corners given clockwise from above.
static func ground_quad(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3, d: Vector3, color: Color) -> void:
	st.set_color(color)
	st.set_normal(Vector3.UP)
	for v in [a, b, c, a, c, d]:
		st.add_vertex(v)


## Thin box from `a` to `b` (poles, wires, rebar, frames).
static func segment(st: SurfaceTool, a: Vector3, b: Vector3, thickness: float, color: Color) -> void:
	var d := b - a
	var length := d.length()
	if length < 0.001:
		return
	var up := Vector3.UP if absf(d.normalized().y) < 0.99 else Vector3.RIGHT
	box(st, (a + b) * 0.5, Vector3(thickness, thickness, length), color, Basis.looking_at(d, up))


## Wire hanging between two points, sagging by `sag` metres in the middle.
static func wire(st: SurfaceTool, a: Vector3, b: Vector3, sag: float, color: Color, pieces := 6) -> void:
	var prev := a
	for i in range(1, pieces + 1):
		var t := float(i) / pieces
		var p := a.lerp(b, t) - Vector3(0, sag * 4.0 * t * (1.0 - t), 0)
		segment(st, prev, p, 0.035, color)
		prev = p


## Upright n-sided prism (tanks, poles, tyres, drums).
static func prism(st: SurfaceTool, base_center: Vector3, radius: float, height: float, color: Color, sides := 8) -> void:
	var top := base_center + Vector3(0, height, 0)
	for i in sides:
		var a0 := TAU * i / sides
		var a1 := TAU * (i + 1) / sides
		var p0 := Vector3(cos(a0), 0, sin(a0)) * radius
		var p1 := Vector3(cos(a1), 0, sin(a1)) * radius
		var n := Vector3(cos((a0 + a1) * 0.5), 0, sin((a0 + a1) * 0.5))
		st.set_color(color)
		st.set_normal(n)
		for v in [top + p0, top + p1, base_center + p1, top + p0, base_center + p1, base_center + p0]:
			st.add_vertex(v)
		st.set_normal(Vector3.UP)
		for v in [top, top + p1, top + p0]:
			st.add_vertex(v)


## Market umbrella: a shallow cone canopy (visible from above and below) on a pole.
static func umbrella(st: SurfaceTool, base: Vector3, radius: float, height: float, color: Color, alt_color: Color, sides := 8) -> void:
	segment(st, base, base + Vector3(0, height, 0), 0.05, Color(0.85, 0.85, 0.85))
	var apex := base + Vector3(0, height + 0.35, 0)
	var rim_y := base.y + height - 0.15
	for i in sides:
		var a0 := TAU * i / sides
		var a1 := TAU * (i + 1) / sides
		var p0 := Vector3(base.x + cos(a0) * radius, rim_y, base.z + sin(a0) * radius)
		var p1 := Vector3(base.x + cos(a1) * radius, rim_y, base.z + sin(a1) * radius)
		var c := color if i % 2 == 0 else alt_color
		st.set_color(c)
		st.set_normal(Vector3.UP)
		for v in [apex, p1, p0]:
			st.add_vertex(v)
		st.set_color(c.darkened(0.25))
		st.set_normal(Vector3.DOWN)
		for v in [apex, p0, p1]:
			st.add_vertex(v)


static var _noise: NoiseTexture2D


## Shared weathering material (see world/weathered.gdshader).
static func weathered(grime := 0.45, streaks := 0.3, dust := 0.35, local := false) -> ShaderMaterial:
	var key := "w_%s_%s_%s_%s" % [grime, streaks, dust, local]
	if _materials.has(key):
		return _materials[key]
	if _noise == null:
		var fn := FastNoiseLite.new()
		fn.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
		fn.frequency = 0.02
		fn.fractal_octaves = 4
		_noise = NoiseTexture2D.new()
		_noise.width = 256
		_noise.height = 256
		_noise.seamless = true
		_noise.generate_mipmaps = true
		_noise.noise = fn
	var mat := ShaderMaterial.new()
	mat.shader = preload("res://world/weathered.gdshader")
	mat.set_shader_parameter("noise_tex", _noise)
	mat.set_shader_parameter("grime_strength", grime)
	mat.set_shader_parameter("streak_strength", streaks)
	mat.set_shader_parameter("dust_strength", dust)
	mat.set_shader_parameter("local_space", local)
	_materials[key] = mat
	return mat


static func weathered_instance(st: SurfaceTool, grime := 0.45, streaks := 0.3, dust := 0.35) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	st.index()
	mi.mesh = st.commit()
	mi.material_override = weathered(grime, streaks, dust)
	return mi


static func begin() -> SurfaceTool:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	return st


## Shared vertex-colour material (one per roughness/unshaded combination).
static func material(roughness := 0.85, unshaded := false) -> StandardMaterial3D:
	var key := "%s_%s" % [roughness, unshaded]
	if _materials.has(key):
		return _materials[key]
	var mat := StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.roughness = roughness
	if unshaded:
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_materials[key] = mat
	return mat


static func mesh_instance(st: SurfaceTool, roughness := 0.85) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	st.index()
	mi.mesh = st.commit()
	mi.material_override = material(roughness)
	return mi


## Soft dark ellipse under vehicles; the Compatibility renderer has no decals.
static func blob_shadow(width: float, length: float) -> MeshInstance3D:
	var key := "blob"
	var mat: StandardMaterial3D = _materials.get(key)
	if mat == null:
		var grad := Gradient.new()
		grad.set_color(0, Color(0, 0, 0, 0.55))
		grad.set_color(1, Color(0, 0, 0, 0.0))
		var tex := GradientTexture2D.new()
		tex.gradient = grad
		tex.fill = GradientTexture2D.FILL_RADIAL
		tex.fill_from = Vector2(0.5, 0.5)
		tex.fill_to = Vector2(1.0, 0.5)
		tex.width = 64
		tex.height = 64
		mat = StandardMaterial3D.new()
		mat.albedo_texture = tex
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mat.no_depth_test = false
		_materials[key] = mat
	var plane := PlaneMesh.new()
	plane.size = Vector2(width, length)
	var mi := MeshInstance3D.new()
	mi.mesh = plane
	mi.material_override = mat
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return mi
