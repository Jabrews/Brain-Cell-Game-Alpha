extends Node

# components
@onready var initate_stat_style : Node = $InitiateStatStyle
@onready var progress_circles : Array[TextureRect] = [
	$Stats/Strength/ProgressCircle,
	$Stats/Intelligence/ProgressCircle,
	$Stats/Community/ProgressCircle
]

# component parent station
@onready var parent_station_interface : Node3D = $"../../../.."

# completed overlay
@onready var completed_overlay : Control = $CompletedOverlay

# display helpers
@onready var display_bars : Node = $DisplayBars
@onready var display_progress_circle_caution : Node = $DisplayProgressCircleCaution
@onready var display_estimated_time_left : Node = $DisplayEstimatedTimeLeft
@onready var display_emergency : Node = $DisplayEmergency
@onready var display_start : Node = $DisplayStart


var start_delay_active : bool = true 

func _ready() -> void:
	GLGoalThresholdBus.connect('created_goal_threshold', _handle_created_goal_threshold)
	display_progress_circle_caution._display(false, false, false)
	display_start._display(true)
	display_estimated_time_left._display(0, 0 ,0)
	
func _handle_created_goal_threshold(goal_threshold : ThresholdGoal) : 	
	initate_stat_style._initiate(goal_threshold)

func _refresh() :
	
	
	# display bars and progress circle %
	var strength_amount_to_decrease : int = parent_station_interface.strength_amount_to_decrease 
	var intelligence_amount_to_decrease : int = parent_station_interface.intelligence_amount_to_decrease 
	var community_amount_to_decrease : int = parent_station_interface.community_amount_to_decrease 	
	
	# allow user to end start delay early
	if start_delay_active : 
		display_start._display(false)
		start_delay_active = false
	
	display_bars._display(
		strength_amount_to_decrease,
		intelligence_amount_to_decrease,
		community_amount_to_decrease,
	)
	
	# display caution symbol if not activley decreasing
	var strength_is_decreasing = strength_amount_to_decrease > 0 
	var intelligence_is_decreasing = intelligence_amount_to_decrease > 0 
	var community_is_decreasing = community_amount_to_decrease > 0 
	
	display_progress_circle_caution._display(
		strength_is_decreasing,
		intelligence_is_decreasing,
		community_is_decreasing,
		
	)
	
	# check mark on circle caution
	var left_strength : int = GLGoalThresholdBus.active_goal_threshold.strength.left_stat_value
	var left_intelligence : int = GLGoalThresholdBus.active_goal_threshold.intelligence.left_stat_value
	var left_community : int = GLGoalThresholdBus.active_goal_threshold.community.left_stat_value
	
	display_progress_circle_caution._display_checkmark(
		left_strength,
		left_intelligence,
		left_community	
	)
	
	display_estimated_time_left._display(
		strength_amount_to_decrease,		
		intelligence_amount_to_decrease,
		community_amount_to_decrease,
	)
	
	# handle emergency screen
	if strength_amount_to_decrease == 0 and intelligence_amount_to_decrease == 0 and community_amount_to_decrease == 0 :
		
		# dont start this when start is active
		if start_delay_active : 		
			return
		
		display_emergency._display(true)
	else :
		display_emergency._display(false)
	
	

func _handle_goal_completed() :
	completed_overlay.visible = true
	await get_tree().create_timer(2.0).timeout	
	
	GLPlayerState.player_refrence.queue_free()	

func _handle_start_delay_ended():
	start_delay_active = false
	_refresh()
	
	
	
	
	
	
	
	
	
	
	
