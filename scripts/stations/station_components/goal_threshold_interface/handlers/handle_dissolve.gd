
extends Node

# parent station component
@onready var parent_station_interface : Node3D = $".."

# components
@onready var dissolve_increment_timer : Timer = $DissolveIncrementTimer

@export var STAT_DECREASE : int = 1


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
		_dissolve_stat(
			parent_station_interface.strength_dissolve_cell,
			"strength"
		)
	
	if parent_station_interface.intelligence_dissolve_cell:
		_dissolve_stat(
			parent_station_interface.intelligence_dissolve_cell,
			"intelligence"
		)
	
	if parent_station_interface.community_dissolve_cell:
		_dissolve_stat(
			parent_station_interface.community_dissolve_cell,
			"community"
		)


func _dissolve_stat(cell : BrainCell, stat : String) -> void:
	
	var cell_stat : BrainCellStat
	
	match stat:
		"strength":
			cell_stat = cell.strength
			
		"intelligence":
			cell_stat = cell.intelligence
			
		"community":
			cell_stat = cell.community
			
		_:
			push_error("bad stat: ", stat)
			return
	
	
	# decrease clean value
	cell_stat.value = maxf(
		cell_stat.value - STAT_DECREASE,
		0.0
	)
	
	# once clean reaches defect, decrease defect too
	if cell_stat.value <= cell_stat.defect:
		cell_stat.defect = maxf(
			cell_stat.defect - STAT_DECREASE,
			0.0
		)
	
	# decrease station + goal values
	match stat:
		"strength":
			parent_station_interface.strength_amount_to_decrease = maxi(
				parent_station_interface.strength_amount_to_decrease - STAT_DECREASE,
				0
			)
			
			GLGoalThresholdBus.active_goal_threshold.strength.left_stat_value -= STAT_DECREASE
		
		"intelligence":
			parent_station_interface.intelligence_amount_to_decrease = maxi(
				parent_station_interface.intelligence_amount_to_decrease - STAT_DECREASE,
				0
			)
			
			GLGoalThresholdBus.active_goal_threshold.intelligence.left_stat_value -= STAT_DECREASE
		
		"community":
			parent_station_interface.community_amount_to_decrease = maxi(
				parent_station_interface.community_amount_to_decrease - STAT_DECREASE,
				0
			)
			
			GLGoalThresholdBus.active_goal_threshold.community.left_stat_value -= STAT_DECREASE
	
	# if clean and defect 0.0. disable stat
	if cell_stat.value <= 0.0 and cell_stat.defect <= 0.0 : 
		cell_stat.enabled = false
		parent_station_interface._handle_cell_seats_changed()
	
		
	
	GLCellManagerBus.emit_signal(
		"collected_cell_changed",
		cell
	)
	
