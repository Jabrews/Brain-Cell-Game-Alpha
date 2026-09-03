extends Node

# components
@onready var initate_stat_style : Node = $InitiateStatStyle
@onready var test_math_2 : Node = $TestMath2

func _ready() -> void:
	GLGoalThresholdBus.connect('created_goal_threshold', _handle_created_goal_threshold)
	
func _handle_created_goal_threshold(goal_threshold : ThresholdGoal) : 
	
	initate_stat_style._initiate(goal_threshold)
	#test_math_2._start(goal_threshold)
	#test_math._start(goal_threshold.strength.stat_value)
	
	
