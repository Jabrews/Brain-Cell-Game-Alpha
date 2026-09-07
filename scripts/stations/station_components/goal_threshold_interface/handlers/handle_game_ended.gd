extends Node

# components
@onready var parent_station_interface : Node3D = $".."
@onready var screen_interface : Node2D = $"../GoalScreenTV/TvFrontPannel/SubViewport/GoalThreshold"

func _handle(): 
	
	if GLGoalThresholdBus.active_goal_threshold.strength.left_stat_value <= 0 :	
		parent_station_interface.strength_finished = true
	
	if GLGoalThresholdBus.active_goal_threshold.intelligence.left_stat_value <= 0 :	
		parent_station_interface.intelligence_finished = true
	
	if GLGoalThresholdBus.active_goal_threshold.community.left_stat_value <= 0 :	
		parent_station_interface.community_finished = true
	
	if (
		parent_station_interface.strength_finished and 
		parent_station_interface.intelligence_finished and 
		parent_station_interface.community_finished 
	) :
		screen_interface._handle_goal_completed()
	
	
	
	
	
