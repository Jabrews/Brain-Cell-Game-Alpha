extends Node

# screen components
@onready var screen_stat_threshold_display : Node2D = $"../StatThresholdTV/TvFrontPannel/SubViewport/ScreenStatThresholdDisplay"
@onready var screen_turn_display : Node2D = $"../TurnTV/TvFrontPannel/SubViewport/ScreenTurnsDisplay"

# components
@onready var helper_dissolve_stats : Node = $"../HelperDissolveStats"
@onready var parent_station : Node3D = $".."


func _refresh() :
	
	
	### STAT SCREEN ###
	var dissolved_stats : Array[DissolveStat] = []
	dissolved_stats.append(helper_dissolve_stats.strength_dissolve_stat)
	dissolved_stats.append(helper_dissolve_stats.intelligence_dissolve_stat)
	dissolved_stats.append(helper_dissolve_stats.community_dissolve_stat)
	
	screen_stat_threshold_display.refresh_display._refresh(dissolved_stats)

	### TURN SCREEN ###
	screen_turn_display.refresh_display._refresh()
