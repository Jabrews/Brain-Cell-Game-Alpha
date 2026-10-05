extends Node

# components
@onready var parent_station: Node3D = $".."
@onready var helper_dissolve_cell : Node = $"../HelperDissolveCell"
@onready var helper_refresh_displays: Node = $"../HelperRefreshDisplays"
@onready var elevator_manager : Node = $"../ElevatorManager"
@onready var cinnamtic_camera : Camera3D = $"../CinnamticCamera"

# screen components
@onready var screen_stat_threshold_display: Node2D = $"../StatThresholdTV/TvFrontPannel/SubViewport/ScreenStatThresholdDisplay"


func _handle(dissolving_cell  : DissolvingCell) -> void:
	
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
	
	# finish 
	if dissolving_cell == null or dissolving_cell.corresponding_cell == null : 
		push_error('attempting to end dissolving without dissolving cell : ', dissolving_cell, ' | ', dissolving_cell.corresponding_cell)
	
	else : 
		GLCellManagerBus.emit_signal('delete_selected_collected_cell', dissolving_cell.corresponding_cell)
		elevator_manager._dissolving_cell_finished()
	
	_toggle_cinnamatic(true)
	
	
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
	helper_dissolve_cell._create_inital_dissolving_cell(parent_station.active_threshold_piece)
	
	# refresh screens
	helper_refresh_displays._refresh()
	
	# update incremental values
	GLGameManagerBus.emit_signal('proceed_next_goal_piece')
	
	await get_tree().create_timer(5.5).timeout	
	
	_toggle_cinnamatic(false)
	

func _toggle_cinnamatic(toggle_value : bool) :
	
	if toggle_value : 	
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		GLHideUiBus.emit_signal('toggle_hide_ui', true)
		GLPlayerState.emit_signal('lock_player_position', true)
		GLCinnamaticBus.emit_signal('toggle_goal_cinnamtic', true)
		
		cinnamtic_camera.fov = 100
		
		cinnamtic_camera.current = true
		
		var cam_fov_tween : Tween = create_tween()
		
		cam_fov_tween.tween_property(
			cinnamtic_camera,
			"fov",
			65,
			3.3
		)
	
	else: 		
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		GLHideUiBus.emit_signal('toggle_hide_ui', false)
		GLPlayerState.emit_signal('lock_player_position', false)
		GLCinnamaticBus.emit_signal('toggle_goal_cinnamtic', false)
		
		cinnamtic_camera.current = false
		

		
		
		
		
		
		
	
