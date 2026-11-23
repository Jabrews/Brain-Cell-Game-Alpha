extends Node

@onready var light_mesh: MeshInstance3D = $"../../LoadCellPanel/Panel/Light/LightMesh"
@onready var light: SpotLight3D = $"../../LoadCellPanel/Panel/Light/Light"

var on_color: Color = Color.RED
var off_color: Color = Color.WHITE

var wanted_light_energy: float = 20.0

func _set_light_mode(mode: String) -> void:
	
	match mode:
		"off":
			_toggle_light(false)
			
		"green":
			on_color = Color.GREEN
			_toggle_light(true)

		_:
			push_warning("Unknown light mode: " + mode)


func _toggle_light(toggle_value: bool) -> void:

	if toggle_value:
		light.visible = true
		light.light_color = on_color
		light.light_energy = wanted_light_energy
		_set_mesh_color(on_color)
	else:
		light.visible = false
		light.light_energy = 0.0
		_set_mesh_color(off_color)
		

func _set_mesh_color(color: Color) -> void:
	var material := light_mesh.get_active_material(0)

	if material is StandardMaterial3D:
		material.albedo_color = color
