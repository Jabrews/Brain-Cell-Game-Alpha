extends Node

# helper components
@onready var helper_dissolve_stats : Node = $HelperDissolveStats
@onready var helper_refresh_displays : Node = $HelperRefreshDisplays

var goal_threshold : GoalThreshold
var active_threshold_piece : ThresholdPiece 


func _ready() -> void:
	GLGoalThresholdManagerBus.connect('created_goal_threshold', _handle_created_goal_threshold)

func _handle_created_goal_threshold(new_goal_threshold : GoalThreshold) :
	
		goal_threshold = new_goal_threshold
		
		# starts at piece 1
		active_threshold_piece = goal_threshold.pieces[1]
		
		# create dissolve stats
		helper_dissolve_stats._create_inital_stats(active_threshold_piece)
		
		# refresh screens
		helper_refresh_displays._refresh()
	
	
	
	
	
	
