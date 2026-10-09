extends Node

# components
@onready var parent_ideal_stat_creator : Node = $".."


# screen components
@onready var screen_ideal_stats : Array[Node2D] = [
	$"../../../IdealStatCreator/IdealStatsWall/IdealStats/IdealStrength/IdealTV/SubViewport/IdealStat",
	$"../../../IdealStatCreator/IdealStatsWall/IdealStats/IdealIntelligence/IdealTV/SubViewport/IdealStat", 
	$"../../../IdealStatCreator/IdealStatsWall/IdealStats/IdealCommunity/IdealTV/SubViewport/IdealStat"
]
@onready var screen_selected_ideal_stat : Node2D = $"../../../IdealStatCreator/ControlInterface/SelectedIdealStatDisplay/TvFrontPanel/SubViewport/SelectedIdealStat"
@onready var screen_energy_display : Node2D = $"../../../IdealStatCreator/EnergyDisplay/TvFrontPannel/SubViewport/EnergyDisplay"

const STATS : Array[String] = ['strength', 'intelligence', 'community']


func _handle() :
	
	## ideal stats on wall
	var ideal_stats_values : Dictionary[String, float] = parent_ideal_stat_creator.ideal_stats_value 
	var ideal_stats_enabled : Dictionary[String, bool] = parent_ideal_stat_creator.ideal_stats_enabled 
	var ideal_stats_lock_max_value : Dictionary[String, float] = parent_ideal_stat_creator.ideal_stats_lock_max_value 
	
	var curr_index = 0
	
	while curr_index <= 2 :  #str, int, com
		
		var n_selected_stat : String = STATS[curr_index]
		
		var ideal_stat_value : float = ideal_stats_values[n_selected_stat]
		var ideal_stat_enabled : bool = ideal_stats_enabled[n_selected_stat]
		var ideal_stat_lock_max_value : float = ideal_stats_lock_max_value[n_selected_stat]
		
		screen_ideal_stats[curr_index].refresh_screen._refresh(ideal_stat_value, ideal_stat_enabled, ideal_stat_lock_max_value)
		
		curr_index += 1
	
	## selected ideal stat view
	
	var selected_stat : String = parent_ideal_stat_creator.selected_stat
	
	var stat_value : float = 0.0
	var stat_enabled: bool = false
	var stat_lock_max_value : float = 0.0
	
	# make sure its not none before propigating
	if selected_stat != 'none': 	
		stat_value = ideal_stats_values[selected_stat]
		stat_enabled = ideal_stats_enabled[selected_stat]
		stat_lock_max_value = ideal_stats_lock_max_value[selected_stat]
	
	
	screen_selected_ideal_stat.refresh_screen._refresh(selected_stat, stat_value, stat_enabled, stat_lock_max_value)
		
		
		
