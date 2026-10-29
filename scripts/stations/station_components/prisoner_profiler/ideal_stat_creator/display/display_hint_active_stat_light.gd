
extends Node

@onready var spotlights: Array[SpotLight3D] = [
	$"../../../IdealStatCreator/ControlInterface/HintActiveStatLight/StrengthLight/SpotLight3D",
	$"../../../IdealStatCreator/ControlInterface/HintActiveStatLight/IntelligenceLight/SpotLight3D",
	$"../../../IdealStatCreator/ControlInterface/HintActiveStatLight/CommunityLight/SpotLight3D"
]

@onready var light_meshes: Array[MeshInstance3D] = [
	$"../../../IdealStatCreator/ControlInterface/HintActiveStatLight/StrengthLight/MeshInstance3D",
	$"../../../IdealStatCreator/ControlInterface/HintActiveStatLight/IntelligenceLight/MeshInstance3D",
	$"../../../IdealStatCreator/ControlInterface/HintActiveStatLight/CommunityLight/MeshInstance3D"
]

const ON_COLOR: Color = Color.RED
const OFF_COLOR: Color = Color.GRAY

const SPOTLIGHT_ON_ENERGY: float = 0.6
const SPOTLIGHT_OFF_ENERGY: float = 0.0

var highlight_materials: Array[StandardMaterial3D] = []


func _ready() -> void:
	for index: int in range(light_meshes.size()):
		light_meshes[index].visible = true
		spotlights[index].visible = true

		var active_material: Material = light_meshes[index].get_active_material(0)
		if active_material is StandardMaterial3D:
			var material_copy := active_material.duplicate() as StandardMaterial3D
			light_meshes[index].material_override = material_copy
			highlight_materials.append(material_copy)
		else:
			push_error("Highlight mesh needs a StandardMaterial3D.")
			highlight_materials.append(null)

	_display_type(-1)


func _display_type(selected_stat_index: int) -> void:
	for index: int in range(spotlights.size()):
		light_meshes[index].visible = true
		spotlights[index].visible = true

		spotlights[index].light_color = OFF_COLOR
		spotlights[index].light_energy = SPOTLIGHT_OFF_ENERGY

		if highlight_materials[index] != null:
			highlight_materials[index].albedo_color = OFF_COLOR

	if selected_stat_index < 0 or selected_stat_index >= spotlights.size():
		return

	spotlights[selected_stat_index].light_color = ON_COLOR
	spotlights[selected_stat_index].light_energy = SPOTLIGHT_ON_ENERGY

	if highlight_materials[selected_stat_index] != null:
		highlight_materials[selected_stat_index].albedo_color = ON_COLOR
