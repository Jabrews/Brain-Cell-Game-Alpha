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

## death chance

# left 
@onready var l_death_chance_parent : Control = $"../../BreedingUI/CellLoader/BreedingView/DeathChanceDisplay/LeftDeathChanceDisplay"
@onready var l_death_chance_percant_label : Label = $"../../BreedingUI/CellLoader/BreedingView/DeathChanceDisplay/LeftDeathChanceDisplay/TotalDeathChance/DeathChancePercant"
@onready var l_death_chance_frame : TextureRect = $"../../BreedingUI/CellLoader/BreedingView/DeathChanceDisplay/LeftDeathChanceDisplay/TotalDeathChance/Frame"

# right  
@onready var r_death_chance_parent : Control = $"../../BreedingUI/CellLoader/BreedingView/DeathChanceDisplay/RightDeathChanceDisplay"
@onready var r_death_chance_percant_label : Label = $"../../BreedingUI/CellLoader/BreedingView/DeathChanceDisplay/RightDeathChanceDisplay/TotalDeathChance/DeathChancePercant"
@onready var r_death_chance_frame : TextureRect = $"../../BreedingUI/CellLoader/BreedingView/DeathChanceDisplay/RightDeathChanceDisplay/TotalDeathChance/Frame"

## blood type

# left
@onready var l_blood_type_parent : Control = $"../../BreedingUI/CellLoader/BreedingView/BloodType/LeftBloodTypeDisplay"
@onready var l_no_blood_type_parent : Control = $"../../BreedingUI/CellLoader/BreedingView/BloodType/LeftBloodTypeDisplay/NoBloodType"

# right 
@onready var r_blood_type_parent : Control = $"../../BreedingUI/CellLoader/BreedingView/BloodType/RightBloodTypeDisplay"
@onready var r_no_blood_type_parent : Control = $"../../BreedingUI/CellLoader/BreedingView/BloodType/RightBloodTypeDisplay/NoBloodType"


func _ready() -> void:
	for bar : Sprite2D in l_clean_bars : 
		bar.material = bar.material.duplicate()
	
	for bar : Sprite2D in r_clean_bars : 
		bar.material = bar.material.duplicate()
		
	l_death_chance_frame.material = l_death_chance_frame.material.duplicate()
	r_death_chance_frame.material = r_death_chance_frame.material.duplicate()


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

func _get_death_chance(side : String) -> Dictionary : 
	
	match side : 
		'left' :
			return {
				'death_chance_parent' : l_death_chance_parent,
				'death_chance_percant_label' :  l_death_chance_percant_label,
				'death_chance_frame' :  l_death_chance_frame,
			}
		'right' :
			return {
				'death_chance_parent' : r_death_chance_parent,
				'death_chance_percant_label' :  r_death_chance_percant_label,
				'death_chance_frame' :  r_death_chance_frame,
			}
		_ : 
			push_error("Invalid side: ", side)
			return {}

func _get_blood_type(side : String) -> Dictionary : 
	match side : 
		'left':
			return {
				'blood_type_parent'	 : l_blood_type_parent,
				'no_blood_type_parent' : l_no_blood_type_parent,
			}
		'right' :
			return {
				'blood_type_parent'	 : r_blood_type_parent,
				'no_blood_type_parent' : r_no_blood_type_parent,
			}
		_ : 
			push_error("Invalid side: ", side)
			return {}
	
