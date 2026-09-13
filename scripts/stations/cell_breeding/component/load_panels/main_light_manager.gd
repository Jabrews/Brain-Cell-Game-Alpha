extends Node

@onready var light_mesh: MeshInstance3D = $LightMesh
@onready var light: SpotLight3D = $Light

var on_color: Color = Color.RED
var off_color: Color = Color.WHITE

#func _ready() -> void:
	#light_mesh.material = light_mesh.material.duplicate()

func _toggle_light(toggle_value: bool) -> void:
	if toggle_value:
		light.visible = true
		light.light_color = on_color
		_set_mesh_color(on_color)
	else:
		light.visible = false
		_set_mesh_color(off_color)


func _set_mesh_color(color: Color) -> void:
	var material := light_mesh.get_active_material(0)

	if material is StandardMaterial3D:
		material.albedo_color = color
