extends Node

# cell manager component
@onready var energy_boost_cell_manager: Node = $"../../../MainCellManager/EnergyBoostCellManager"
@onready var main_cell_manager: Node = $"../../../MainCellManager"

# parent cycle event
@onready var parent_handle_cycle_btn_pressed: Node = $".."

var stats: Array[String] = ["community", "intelligence", "strength"]


func _check_stats_validity(side: String) -> bool:
	# get cells
	var energy_boost_left_cell: BrainCell = energy_boost_cell_manager.energy_boost_left_cell
	var energy_boost_right_cell: BrainCell = energy_boost_cell_manager.energy_boost_right_cell
	
	var main_left_cell: BrainCell = main_cell_manager.main_left_cell
	var main_right_cell: BrainCell = main_cell_manager.main_right_cell
	
	# get indexes
	var left_index: int = parent_handle_cycle_btn_pressed.left_index
	var right_index: int = parent_handle_cycle_btn_pressed.right_index
	
	# get stat types safely
	var left_stat_type: String = _get_stat_type_from_index(left_index)
	var right_stat_type: String = _get_stat_type_from_index(right_index)
	
	# check validity
	var left_boost_stat_is_valid: bool = find_stat_is_valid(energy_boost_left_cell, left_stat_type)
	var right_boost_stat_is_valid: bool = find_stat_is_valid(energy_boost_right_cell, right_stat_type)
	
	var left_main_stat_is_valid: bool = find_stat_is_valid(main_left_cell, left_stat_type)
	var right_main_stat_is_valid: bool = find_stat_is_valid(main_right_cell, right_stat_type)
	
	var left_is_valid: bool = left_boost_stat_is_valid and left_main_stat_is_valid
	var right_is_valid: bool = right_boost_stat_is_valid and right_main_stat_is_valid
	
	# save valid selected stat, otherwise none
	energy_boost_cell_manager.energy_boost_left_stat = left_stat_type if left_is_valid else "none"
	energy_boost_cell_manager.energy_boost_right_stat = right_stat_type if right_is_valid else "none"
	
	# return + feedback for requested side
	match side:
		"left":
			if left_is_valid:
				return true
			
			else : 
				return false
			
		
		"right":
			if right_is_valid:
				return true
				
			else : 
				return false
		
		_ : 
			push_error('no side found')
			return false


func _get_stat_type_from_index(index: int) -> String:
	if index < 0 or index >= stats.size():
		return "none"
	
	return stats[index]


func find_stat_is_valid(cell: BrainCell, stat_type: String) -> bool:
	if cell == null:
		return false
	
	if stat_type == "none":
		return false
	
	var stat: BrainCellStat = null
	
	match stat_type:
		"strength":
			stat = cell.strength
		"intelligence":
			stat = cell.intelligence
		"community":
			stat = cell.community
		_:
			push_error("Invalid stat_type passed into find_stat_is_valid: " + stat_type)
			return false
	
	if stat == null:
		return false
	
	if not stat.enabled:
		return false
	
	if stat.hidden:
		return false
	
	return true
