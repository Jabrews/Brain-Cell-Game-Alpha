extends Node

# parent station component
@onready var parent_station_interface : Node3D = $".."

# helper component
@onready var handle_game_ended : Node = $"../HandleGameEnded"


# components
@onready var dissolve_increment_timer : Timer = $DissolveIncrementTimer

@export var STAT_DECREASE : int = 10


func _ready() -> void:
	dissolve_increment_timer.connect(
		"timeout",
		_handle_dissolve_increment_timer_timeout
	)


func _dissolve_cells_changed() -> void:
	
	if (
		parent_station_interface.strength_dissolve_cell or
		parent_station_interface.intelligence_dissolve_cell or
		parent_station_interface.community_dissolve_cell
	):
		dissolve_increment_timer.start()
	else:
		dissolve_increment_timer.stop()


func _handle_dissolve_increment_timer_timeout() -> void:
	
	if parent_station_interface.strength_dissolve_cell:
		if not parent_station_interface.strength_finished:
			_dissolve_stat(
				parent_station_interface.strength_dissolve_cell,
				"strength"
			)
	
	if parent_station_interface.intelligence_dissolve_cell:
		if not parent_station_interface.intelligence_finished:
			_dissolve_stat(
				parent_station_interface.intelligence_dissolve_cell,
				"intelligence"
			)
	
	if parent_station_interface.community_dissolve_cell:
		if not parent_station_interface.community_finished:
			_dissolve_stat(
				parent_station_interface.community_dissolve_cell,
				"community"
			)
	
	
	# stop timer if nothing is dissolving anymore
	_dissolve_cells_changed()
	
	parent_station_interface.screen_goal_threshold_interface._refresh()


func _dissolve_stat(cell : BrainCell, stat : String) -> void:
	
	var cell_stat : BrainCellStat
	var goal_stat
	
	match stat:
		"strength":
			cell_stat = cell.strength
			goal_stat = GLGoalThresholdBus.active_goal_threshold.strength
			
		"intelligence":
			cell_stat = cell.intelligence
			goal_stat = GLGoalThresholdBus.active_goal_threshold.intelligence
			
		"community":
			cell_stat = cell.community
			goal_stat = GLGoalThresholdBus.active_goal_threshold.community
			
		_:
			push_error("bad stat: ", stat)
			return
	
	
	# -------------------------
	# DECREASE CELL STAT
	# -------------------------
	
	cell_stat.value = maxf(
		cell_stat.value - STAT_DECREASE,
		0.0
	)
	
	if cell_stat.value <= cell_stat.defect:
		cell_stat.defect = maxf(
			cell_stat.defect - STAT_DECREASE,
			0.0
		)
	
	
	# -------------------------
	# DECREASE GOAL
	# -------------------------
	
	goal_stat.left_stat_value = maxi(
		goal_stat.left_stat_value - STAT_DECREASE,
		0
	)
	
	
	# -------------------------
	# DECREASE STATION AMOUNT
	# -------------------------
	
	match stat:
		"strength":
			parent_station_interface.strength_amount_to_decrease = maxi(
				parent_station_interface.strength_amount_to_decrease - STAT_DECREASE,
				0
			)
		
		"intelligence":
			parent_station_interface.intelligence_amount_to_decrease = maxi(
				parent_station_interface.intelligence_amount_to_decrease - STAT_DECREASE,
				0
			)
		
		"community":
			parent_station_interface.community_amount_to_decrease = maxi(
				parent_station_interface.community_amount_to_decrease - STAT_DECREASE,
				0
			)
	
	
	# -------------------------
	# CELL STAT EMPTY
	# -------------------------
	
	if cell_stat.value <= 0.0:
		
		cell_stat.enabled = false
		
		_clear_dissolve_cell(
			stat,
			cell
		)
		
		GLCellManagerBus.emit_signal(
			"collected_cell_changed",
			cell
		)
		
		# look for another valid dissolve cell
		parent_station_interface._handle_cell_seats_changed()
		
		return
	
	
	# -------------------------
	# GOAL STAT FINISHED
	# -------------------------
	
	if goal_stat.left_stat_value <= 0:
		
		_clear_dissolve_cell(
			stat,
			cell
		)
		
		match stat:
			"strength":
				parent_station_interface.strength_finished = true
				parent_station_interface._handle_cell_seats_changed()
				handle_game_ended._handle()
			
			"intelligence":
				parent_station_interface.intelligence_finished = true
				parent_station_interface._handle_cell_seats_changed()
				handle_game_ended._handle()
			
			"community":
				parent_station_interface.community_finished = true
				parent_station_interface._handle_cell_seats_changed()
				handle_game_ended._handle()
	
	GLCellManagerBus.emit_signal(
		"collected_cell_changed",
		cell
	)


func _clear_dissolve_cell(
	stat : String,
	cell : BrainCell
) -> void:
	
	match stat:
		"strength":
			parent_station_interface.strength_dissolve_cell = null
		
		"intelligence":
			parent_station_interface.intelligence_dissolve_cell = null
		
		"community":
			parent_station_interface.community_dissolve_cell = null
	
	GLGoalThresholdBus.dissolving_cells_on_goal_threshold_panel.erase(
		cell.name
	)
