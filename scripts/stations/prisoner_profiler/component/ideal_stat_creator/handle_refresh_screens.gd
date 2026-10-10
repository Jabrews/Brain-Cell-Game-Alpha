extends Node

# components
@onready var parent_ideal_stat_creator: Node = $".."
@onready var screen_ideal_stats: Array[Node2D] = [
	$"../../../IdealStatCreator/IdealStatsWall/IdealStats/IdealStrength/IdealTV/SubViewport/IdealStat",
	$"../../../IdealStatCreator/IdealStatsWall/IdealStats/IdealIntelligence/IdealTV/SubViewport/IdealStat",
	$"../../../IdealStatCreator/IdealStatsWall/IdealStats/IdealCommunity/IdealTV/SubViewport/IdealStat"
]
@onready var screen_selected_ideal_stat: Node2D = $"../../../IdealStatCreator/ControlInterface/SelectedIdealStatDisplay/TvFrontPanel/SubViewport/SelectedIdealStat"
@onready var screen_energy_display : Node2D = $"../../../IdealStatCreator/EnergyDisplay/TvFrontPannel/SubViewport/EnergyDisplay"


func _handle() -> void:
	
	var ideal_stats: Array[IdealStat] = parent_ideal_stat_creator.get_ideal_stats()

	## deal with ideal stats on wall
	for index: int in range(ideal_stats.size()):
		var refresh_screen: Node = screen_ideal_stats[index].refresh_screen
		refresh_screen._refresh(ideal_stats[index])

	## deal with selected ideal stat
	var selected_stat_type : String = parent_ideal_stat_creator.selected_stat
	var selected_ideal_stat : IdealStat = null

	for ideal_stat: IdealStat in ideal_stats:
		if ideal_stat.stat_type == selected_stat_type:
			selected_ideal_stat = ideal_stat			
			
	var selected_refresh_screen: Node = screen_selected_ideal_stat.refresh_screen
	selected_refresh_screen._refresh(selected_ideal_stat)
	
	## TODO
	## deal with screen energy display
	#screen_energy_display.
