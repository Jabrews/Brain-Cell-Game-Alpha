extends Node

## boost 

# left
@onready var l_stat_parents : Array[Control] = [
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Strength",
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Intelligence",
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Community"
]
@onready var l_stat_highlights : Array[Sprite2D] = [
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Strength/Highlight",
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Intelligence/Highlight",
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Community/Highlight"
]

@onready var l_up_charge_direction_btn : Control = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/ChargeDirectionBtns/UpBtn"
@onready var l_down_charge_direction_btn : Control = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/ChargeDirectionBtns/DownBtn"
@onready var l_up_charge_direction_btn_highlight : ColorRect = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/ChargeDirectionBtns/UpBtn/HoverRect"
@onready var l_down_charge_direction_btn_highlight : ColorRect = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/ChargeDirectionBtns/DownBtn/HoverRect"

@onready var l_valid_label : Label = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Validity/Valid"
@onready var l_invalid_label : Label = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Validity/Invalid"
@onready var l_none_label : Label = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Validity/None"

## boost stat 

# left
@onready var l_clean_bars : Array[Sprite2D] = [
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Strength/CleanBar", 
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Intelligence/CleanBar", 
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Community/CleanBar"
]
@onready var l_defect_bars : Array[Sprite2D] = [
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Strength/DefectBar", 
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Intelligence/DefectBar", 
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Community/DefectBar"
]
@onready var l_hidden_sprites : Array[Sprite2D] = [
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Strength/HiddenSprite",
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Intelligence/HiddenSprite",
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Community/HiddenSprite"
]
@onready var l_off_parents : Array[Control] = [
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Strength/Off",
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Intelligence/Off",
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Community/Off"
]
@onready var l_cell_name_label : Label = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/CellNameLabel"


func _ready() -> void:
	for l_clean_bar in l_clean_bars : 
		l_clean_bar.material = l_clean_bar.material.duplicate()
	
	for l_defect_bar in l_defect_bars : 
		l_defect_bar .material = l_defect_bar.material.duplicate()


func _get_boost(side: String) -> Dictionary:
	
	match side:
		"left":
			return {
				'stat_parents' : l_stat_parents,
				'stat_highlights' : l_stat_highlights,
				'up_charge_direction_btn' : l_up_charge_direction_btn,
				'down_charge_direction_btn' : l_down_charge_direction_btn,
				'up_charge_direction_btn_highlight' : l_up_charge_direction_btn_highlight,
				'down_charge_direction_btn_highlight' : l_down_charge_direction_btn_highlight,
				'valid_label' : l_valid_label,
				'invalid_label' : l_invalid_label,
				'none_label' : l_none_label,
			}
		
		"right":
			return {
			}
		
		_:
			push_error("Invalid side: ", side)
			return {}

func _get_boost_stat(side : String) -> Dictionary :
	
	match side:
		"left":
			return {
				"clean_bars" : l_clean_bars,
				"defect_bars" : l_defect_bars,
				"hidden_sprites" : l_hidden_sprites,
				"off_parents" : l_off_parents,
				"cell_name_label" : l_cell_name_label,
			}
			
		"right":
			return {
			}
			
		_:
			push_error("Invalid side: ", side)
			return {}
