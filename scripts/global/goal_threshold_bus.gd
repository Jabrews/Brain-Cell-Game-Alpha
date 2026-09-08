extends Node

var active_goal_threshold : ThresholdGoal 

signal created_goal_threshold(goal_threshold: ThresholdGoal)

signal toggle_threshold_emergency_countdown(toggle_value : bool, time_left : int)
signal update_emergency_time_left(time_left : int)

# list of cell names
var dissolving_cells_on_goal_threshold_panel : Array[String] = []
