extends Node

# helper components
@onready var helper_dissolve_cell : Node = $HelperDissolveCell
@onready var helper_refresh_displays : Node = $HelperRefreshDisplays

var goal_threshold : GoalThreshold
var active_threshold_piece : ThresholdPiece 


func _ready() -> void:
	GLGoalThresholdManagerBus.connect('created_goal_threshold', _handle_created_goal_threshold)
	GLGameManagerBus.connect('proceed_next_turn', _handle_next_turn)
	
func _handle_created_goal_threshold(new_goal_threshold : GoalThreshold) :
	
	goal_threshold = new_goal_threshold
	
	# starts at piece 1
	active_threshold_piece = goal_threshold.pieces[1]
	
	# create dissolve stats
	helper_dissolve_cell._create_inital_dissolving_cell(active_threshold_piece)
	
	# refresh screens
	helper_refresh_displays._refresh()
	

func _handle_next_turn() -> void:
	
	if active_threshold_piece == null:
		return
	
	# decrease turn count
	active_threshold_piece.turns_remaining -= 1
	
	# warning if last turn
	if active_threshold_piece.turns_remaining == 0 : 
		GLEventNoticeManagerBus.emit_signal('create_event_notice', EventNotice.new('turn_warning', 'Finale Turn. Last chance to reach Stat Goal', {}))
		GLGoalThresholdManagerBus.emit_signal('toggle_emergency_ui', true)
	else : 
		GLGoalThresholdManagerBus.emit_signal('toggle_emergency_ui', false)
	
	# end game
	if active_threshold_piece.turns_remaining < 0 : 
		GLEndStateScreenBus.emit_signal('game_ended')
	
	# keep manager reference synced
	GLGoalThresholdManagerBus.active_goal_threshold = goal_threshold
	
	# refresh screens
	helper_refresh_displays._refresh()
	
