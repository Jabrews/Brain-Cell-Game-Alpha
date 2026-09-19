extends Node

## stat components

# left
@onready var l_no_cell_loaded_label : Label = $"../../BreedingUI/CellLoader/BreedingView/StatDisplay/LeftStatDisplay/NoCellLoadedLabel"
@onready var l_stat_display_parent : Control = $"../../BreedingUI/CellLoader/BreedingView/StatDisplay/LeftStatDisplay/StatDisplay"
@onready var l_cell_name_label : Label = $"../../BreedingUI/CellLoader/BreedingView/StatDisplay/LeftStatDisplay/StatDisplay/CellName"

@onready var l_clean_bars : Array[Sprite2D] = [
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/LeftStatDisplay/StatDisplay/Strength/CleanBar",
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/LeftStatDisplay/StatDisplay/Intelligence/CleanBar",
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/LeftStatDisplay/StatDisplay/Community/CleanBar"
]

@onready var l_defect_bars : Array[TextureProgressBar] = [
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/LeftStatDisplay/StatDisplay/Strength/DefectBar",
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/LeftStatDisplay/StatDisplay/Intelligence/DefectBar",
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/LeftStatDisplay/StatDisplay/Community/DefectBar"
]

@onready var l_hidden_sprites : Array[Sprite2D] = [
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/LeftStatDisplay/StatDisplay/Strength/HiddenSprite",
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/LeftStatDisplay/StatDisplay/Intelligence/HiddenSprite",
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/LeftStatDisplay/StatDisplay/Community/HiddenSprite"
]

@onready var l_off_labels : Array[Label] = [
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/LeftStatDisplay/StatDisplay/Strength/OffLabel",
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/LeftStatDisplay/StatDisplay/Intelligence/OffLabel",
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/LeftStatDisplay/StatDisplay/Community/OffLabel"
]


# right
@onready var r_no_cell_loaded_label : Label = $"../../BreedingUI/CellLoader/BreedingView/StatDisplay/RightStatDisplay/NoCellLoadedLabel"
@onready var r_stat_display_parent : Control = $"../../BreedingUI/CellLoader/BreedingView/StatDisplay/RightStatDisplay/StatDisplay"
@onready var r_cell_name_label : Label = $"../../BreedingUI/CellLoader/BreedingView/StatDisplay/RightStatDisplay/StatDisplay/CellName"

@onready var r_clean_bars : Array[Sprite2D] = [
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/RightStatDisplay/StatDisplay/Strength/CleanBar",
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/RightStatDisplay/StatDisplay/Intelligence/CleanBar",
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/RightStatDisplay/StatDisplay/Community/CleanBar"
]

@onready var r_defect_bars : Array[TextureProgressBar] = [
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/RightStatDisplay/StatDisplay/Strength/DefectBar",
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/RightStatDisplay/StatDisplay/Intelligence/DefectBar",
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/RightStatDisplay/StatDisplay/Community/DefectBar"
]

@onready var r_hidden_sprites : Array[Sprite2D] = [
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/RightStatDisplay/StatDisplay/Strength/HiddenSprite",
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/RightStatDisplay/StatDisplay/Intelligence/HiddenSprite",
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/RightStatDisplay/StatDisplay/Community/HiddenSprite"
]

@onready var r_off_labels : Array[Label] = [
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/RightStatDisplay/StatDisplay/Strength/OffLabel",
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/RightStatDisplay/StatDisplay/Intelligence/OffLabel",
	$"../../BreedingUI/CellLoader/BreedingView/StatDisplay/RightStatDisplay/StatDisplay/Community/OffLabel"
]


func _get_stat(side: String) -> Dictionary:
	
	match side:
		"left":
			return {
				"no_cell_loaded_label": l_no_cell_loaded_label,
				"stat_display_parent": l_stat_display_parent,
				"cell_name_label": l_cell_name_label,
				"clean_bars": l_clean_bars,
				"defect_bars": l_defect_bars,
				"hidden_sprites": l_hidden_sprites,
				"off_labels": l_off_labels
			}
		
		"right":
			return {
				"no_cell_loaded_label": r_no_cell_loaded_label,
				"stat_display_parent": r_stat_display_parent,
				"cell_name_label": r_cell_name_label,
				"clean_bars": r_clean_bars,
				"defect_bars": r_defect_bars,
				"hidden_sprites": r_hidden_sprites,
				"off_labels": r_off_labels
			}
		
		_:
			push_error("Invalid side: ", side)
			return {}
