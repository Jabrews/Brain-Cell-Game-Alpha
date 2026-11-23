extends MeshInstance3D 

@onready var sub_viewport = $SubViewport

func _ready() -> void:
	var tex = sub_viewport.get_texture()
	
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_texture = tex
	
	material_override = mat
