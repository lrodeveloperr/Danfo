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
