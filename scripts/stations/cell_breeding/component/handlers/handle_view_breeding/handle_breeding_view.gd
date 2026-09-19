extends Node

# get helper
@onready var get_side_components : Node = $GetSideComponents 

# display components
@onready var display_stats : Node = $Display/DisplayStats

# reset components
@onready var reset_stats : Node = $Reset/ResetStats


func _handle() -> void:
	
	var panel_cells : Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_ui_state	
	
	# get main cells
	var left_main_cell : BrainCell = panel_cells["left_main"]
	var right_main_cell : BrainCell = panel_cells["right_main"]
	
	# left side
	var left_stat_components : Dictionary = get_side_components._get_stat("left")
	display_stats._display(left_main_cell, left_stat_components)
	
	# right side
	var right_stat_components : Dictionary = get_side_components._get_stat("right")
	display_stats._display(right_main_cell, right_stat_components)
