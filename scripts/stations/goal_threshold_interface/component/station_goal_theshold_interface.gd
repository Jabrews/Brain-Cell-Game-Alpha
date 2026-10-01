extends Node

# helper components
@onready var helper_dissolve_stats : Node = $HelperDissolveStats
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
	helper_dissolve_stats._create_inital_stats(active_threshold_piece)
	
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
	
func _handle_threshold_stat_finished() -> void:
	
	var strength_stat_threshold: ThresholdStat = active_threshold_piece.strength
	var intelligence_stat_threshold: ThresholdStat = active_threshold_piece.intelligence
	var community_stat_threshold: ThresholdStat = active_threshold_piece.community
	
	# check if all stats are either finished or disabled
	var strength_complete: bool = strength_stat_threshold.finished or strength_stat_threshold.disabled
	
	var intelligence_complete: bool = intelligence_stat_threshold.finished or intelligence_stat_threshold.disabled
	
	var community_complete: bool = community_stat_threshold.finished or community_stat_threshold.disabled
	
	if (
		strength_complete
		and intelligence_complete
		and community_complete
	):
		
		goal_threshold.active_piece_index += 1

		# finish game if the next goal piece does not exist
		if not goal_threshold.pieces.has(goal_threshold.active_piece_index):
			GLEndStateScreenBus.emit_signal("game_finished")
			return

		# move to next goal piece
		active_threshold_piece = goal_threshold.pieces[
			goal_threshold.active_piece_index
		]
		
		# TODO 
		# when finished with a goal make sure the cell currently dissolving dies first
		# DONT want it to carry over

		# create dissolve stats
		helper_dissolve_stats._create_inital_stats(active_threshold_piece)

		# refresh screens
		helper_refresh_displays._refresh()
				
				
			
	
	
	
	
	
	
	
	
	
	
	
	
