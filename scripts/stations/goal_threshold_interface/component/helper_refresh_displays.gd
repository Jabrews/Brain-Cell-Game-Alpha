extends Node

# screen components
@onready var screen_stat_threshold_display : Node2D = $"../StatThresholdTV/TvFrontPannel/SubViewport/ScreenStatThresholdDisplay"
@onready var screen_turn_display : Node2D = $"../TurnTV/TvFrontPannel/SubViewport/ScreenTurnsDisplay"

# helper components
@onready var helper_dissolve_stats : Node = $"../HelperDissolveStats"


func _refresh() :
	
	var dissolved_stats : Array[DissolveStat] = []
	dissolved_stats.append(helper_dissolve_stats.strength_dissolve_stat)
	dissolved_stats.append(helper_dissolve_stats.intelligence_dissolve_stat)
	dissolved_stats.append(helper_dissolve_stats.community_dissolve_stat)
	
	screen_stat_threshold_display.refresh_display._refresh(dissolved_stats)
