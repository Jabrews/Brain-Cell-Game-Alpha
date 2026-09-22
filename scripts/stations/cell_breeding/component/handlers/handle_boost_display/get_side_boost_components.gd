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


# right
@onready var r_stat_parents : Array[Control] = [
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Strength",
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Intelligence",
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Community"
]
@onready var r_stat_highlights : Array[Sprite2D] = [
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Strength/Highlight",
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Intelligence/Highlight",
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Community/Highlight"
]

@onready var r_up_charge_direction_btn : Control = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/ChargeDirectionBtns/UpBtn"
@onready var r_down_charge_direction_btn : Control = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/ChargeDirectionBtns/DownBtn"
@onready var r_up_charge_direction_btn_highlight : ColorRect = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/ChargeDirectionBtns/UpBtn/HoverRect"
@onready var r_down_charge_direction_btn_highlight : ColorRect = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/ChargeDirectionBtns/DownBtn/HoverRect"

@onready var r_valid_label : Label = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Validity/Valid"
@onready var r_invalid_label : Label = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Validity/Invalid"
@onready var r_none_label : Label = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Validity/None"


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
@onready var l_death_alert_sprites : Array[Sprite2D] = [
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Strength/DeathAlert", 
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Intelligence/DeathAlert", 
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/Stats/Community/DeathAlert"
]


# right
@onready var r_clean_bars : Array[Sprite2D] = [
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Strength/CleanBar", 
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Intelligence/CleanBar", 
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Community/CleanBar"
]
@onready var r_defect_bars : Array[Sprite2D] = [
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Strength/DefectBar", 
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Intelligence/DefectBar", 
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Community/DefectBar"
]
@onready var r_hidden_sprites : Array[Sprite2D] = [
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Strength/HiddenSprite",
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Intelligence/HiddenSprite",
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Community/HiddenSprite"
]
@onready var r_off_parents : Array[Control] = [
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Strength/Off",
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Intelligence/Off",
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Community/Off"
]
@onready var r_cell_name_label : Label = $"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/CellNameLabel"
@onready var r_death_alert_sprites : Array[Sprite2D] = [
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Strength/DeathAlert", 
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Intelligence/DeathAlert", 
	$"../../BreedingUI/CellLoader/BreedingView/BoostDisplays/RightBoostDisplay/Stats/Community/DeathAlert"
]


func _ready() -> void:
	for l_clean_bar in l_clean_bars: 
		l_clean_bar.material = l_clean_bar.material.duplicate()
	
	for l_defect_bar in l_defect_bars: 
		l_defect_bar.material = l_defect_bar.material.duplicate()
	
	for r_clean_bar in r_clean_bars: 
		r_clean_bar.material = r_clean_bar.material.duplicate()
	
	for r_defect_bar in r_defect_bars: 
		r_defect_bar.material = r_defect_bar.material.duplicate()


func _get_boost(side: String) -> Dictionary:
	
	match side:
		"left":
			return {
				"stat_parents" : l_stat_parents,
				"stat_highlights" : l_stat_highlights,
				"up_charge_direction_btn" : l_up_charge_direction_btn,
				"down_charge_direction_btn" : l_down_charge_direction_btn,
				"up_charge_direction_btn_highlight" : l_up_charge_direction_btn_highlight,
				"down_charge_direction_btn_highlight" : l_down_charge_direction_btn_highlight,
				"valid_label" : l_valid_label,
				"invalid_label" : l_invalid_label,
				"none_label" : l_none_label,
			}
		
		"right":
			return {
				"stat_parents" : r_stat_parents,
				"stat_highlights" : r_stat_highlights,
				"up_charge_direction_btn" : r_up_charge_direction_btn,
				"down_charge_direction_btn" : r_down_charge_direction_btn,
				"up_charge_direction_btn_highlight" : r_up_charge_direction_btn_highlight,
				"down_charge_direction_btn_highlight" : r_down_charge_direction_btn_highlight,
				"valid_label" : r_valid_label,
				"invalid_label" : r_invalid_label,
				"none_label" : r_none_label,
			}
		
		_:
			push_error("Invalid side: ", side)
			return {}


func _get_boost_stat(side : String) -> Dictionary:
	
	match side:
		"left":
			return {
				"clean_bars" : l_clean_bars,
				"defect_bars" : l_defect_bars,
				"hidden_sprites" : l_hidden_sprites,
				"off_parents" : l_off_parents,
				"cell_name_label" : l_cell_name_label,
				"death_alert_sprites" : l_death_alert_sprites
			}
			
		"right":
			return {
				"clean_bars" : r_clean_bars,
				"defect_bars" : r_defect_bars,
				"hidden_sprites" : r_hidden_sprites,
				"off_parents" : r_off_parents,
				"cell_name_label" : r_cell_name_label,
				"death_alert_sprites" : r_death_alert_sprites
			}
			
		_:
			push_error("Invalid side: ", side)
			return {}
