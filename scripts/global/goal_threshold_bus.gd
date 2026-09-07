extends Node

var active_goal_threshold : ThresholdGoal 

signal created_goal_threshold(goal_threshold: ThresholdGoal)

# list of cell names
var dissolving_cells_on_goal_threshold_panel : Array[String] = []


func _process(delta: float) -> void:
	if Input.is_action_just_pressed('debug1') :
		print(dissolving_cells_on_goal_threshold_panel)
