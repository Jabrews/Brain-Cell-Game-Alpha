extends Node

# screen components
@onready var screen_stat_threshold_display : Node2D = $"../StatThresholdTV/TvFrontPannel/SubViewport/ScreenStatThresholdDisplay"
@onready var screen_turn_display : Node2D = $"../TurnTV/TvFrontPannel/SubViewport/ScreenTurnsDisplay"

# components
@onready var helper_dissolve_cell : Node = $"../HelperDissolveCell"
@onready var parent_station : Node3D = $".."


func _refresh() :
	
	
	### STAT SCREEN ###
	var dissolving_cell : DissolvingCell = helper_dissolve_cell.dissolving_cell 
	screen_stat_threshold_display.refresh_display._refresh(dissolving_cell)

	### TURN SCREEN ###
	screen_turn_display.refresh_display._refresh()
