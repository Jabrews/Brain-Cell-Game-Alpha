extends Node


# Components
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var light: SpotLight3D = $SpotLight3D


var cells_unloaded: Color = Color.RED
var cells_loaded: Color = Color.GREEN
var inactive: Color = Color.WHITE

func _switch_light_state(state: String) -> void:

	match state:

		"cells_loaded":
			light.light_color = cells_loaded
			light.light_energy = 1.0
			_set_mesh_color(cells_loaded)

		"cells_unloaded":
			light.light_color = cells_unloaded 
			light.light_energy = 1.0
			_set_mesh_color(cells_unloaded)

		"inactive":
			light.light_energy = 0.0
			_set_mesh_color(inactive)


func _set_mesh_color(color: Color) -> void:

	mesh.material_override = StandardMaterial3D.new()
	mesh.material_override.albedo_color = color
