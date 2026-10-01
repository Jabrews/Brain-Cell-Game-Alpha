extends Node

# components
@onready var parent_station: Node3D = $".."
@onready var helper_dissolve_stats: Node = $"../HelperDissolveStats"
@onready var helper_refresh_displays: Node = $"../HelperRefreshDisplays"

# screen components
@onready var screen_stat_threshold_display: Node2D = $"../StatThresholdTV/TvFrontPannel/SubViewport/ScreenStatThresholdDisplay"


func _handle() -> void:
	
	var goal_threshold: GoalThreshold = parent_station.goal_threshold
	var active_threshold_piece: ThresholdPiece = parent_station.active_threshold_piece
	
	var strength_stat_threshold: ThresholdStat = active_threshold_piece.strength
	var intelligence_stat_threshold: ThresholdStat = active_threshold_piece.intelligence
	var community_stat_threshold: ThresholdStat = active_threshold_piece.community
	
	# check if all stats are either finished or disabled
	var strength_complete: bool = (
		strength_stat_threshold.finished
		or strength_stat_threshold.disabled
	)
	
	var intelligence_complete: bool = (
		intelligence_stat_threshold.finished
		or intelligence_stat_threshold.disabled
	)
	
	var community_complete: bool = (
		community_stat_threshold.finished
		or community_stat_threshold.disabled
	)
	
	# current piece is not finished yet
	if not (
		strength_complete
		and intelligence_complete
		and community_complete
	):
		return
	
	# move to next piece
	goal_threshold.active_piece_index += 1
	
	# finish game if the next goal piece does not exist
	if not goal_threshold.pieces.has(goal_threshold.active_piece_index):
		GLEndStateScreenBus.emit_signal("game_finished")
		return
	
	# IMPORTANT:
	# update the parent's actual active piece
	parent_station.active_threshold_piece = goal_threshold.pieces[
		goal_threshold.active_piece_index
	]
	
	# keep global reference synced
	GLGoalThresholdManagerBus.active_goal_threshold = goal_threshold
	
	# show new piece loading
	screen_stat_threshold_display.display_new_piece_loading._display(
		goal_threshold
	)
	
	# create dissolve stats for NEW piece
	helper_dissolve_stats._create_inital_stats(
		parent_station.active_threshold_piece
	)
	
	# refresh screens
	helper_refresh_displays._refresh()
