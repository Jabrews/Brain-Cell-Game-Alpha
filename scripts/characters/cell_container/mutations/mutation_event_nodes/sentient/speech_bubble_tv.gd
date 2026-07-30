
extends MeshInstance3D

@onready var sub_viewport: SubViewport = $SubViewport


func _ready() -> void:
	sub_viewport.transparent_bg = true

	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_texture = sub_viewport.get_texture()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.blend_mode = BaseMaterial3D.BLEND_MODE_MIX

	# Only render the front side.
	mat.cull_mode = BaseMaterial3D.CULL_BACK

	# Always face the camera.
	mat.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED

	material_override = mat
