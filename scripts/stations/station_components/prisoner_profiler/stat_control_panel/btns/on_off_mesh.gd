extends MeshInstance3D

func _ready():
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color.BLUE
	material_override = mat
