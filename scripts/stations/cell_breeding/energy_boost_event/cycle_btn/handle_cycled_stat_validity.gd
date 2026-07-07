extends Node

# cell manager component
@onready var energy_boost_cell_manager : Node = $"../../../MainCellManager/EnergyBoostCellManager"
@onready var main_cell_manager : Node = $"../../../MainCellManager"

# parent cycle event
@onready var parent_handle_cycle_btn_pressed : Node = $".."


var stats : Array[String] = ['community', 'intelligence', 'strength']

func _check_stats_validity(side : String) :
	
	# get cells and index (index from parent cycle)
	var energy_boost_left_cell : BrainCell = energy_boost_cell_manager.energy_boost_left_cell
	var energy_boost_right_cell : BrainCell = energy_boost_cell_manager.energy_boost_right_cell
	var main_left_cell : BrainCell =  main_cell_manager.main_left_cell
	var main_right_cell : BrainCell = main_cell_manager.main_right_cell
	
	var left_index : int = parent_handle_cycle_btn_pressed.left_index 
	var right_index : int = parent_handle_cycle_btn_pressed.right_index 
	
	# get stat
	var left_stat_type = stats[left_index]
	var right_stat_type = stats[right_index]
	
	# see if its disabled or hidden (not valid)
	var left_boost_stat_is_valid = find_stat_is_valid(energy_boost_left_cell, left_stat_type)
	var right_boost_stat_is_valid = find_stat_is_valid(energy_boost_right_cell, right_stat_type)
	
	var left_main_stat_is_valid = find_stat_is_valid(main_left_cell, left_stat_type)
	var right_main_stat_is_valid = find_stat_is_valid(main_right_cell, right_stat_type)
	
	# none-invalid stat-valid
	if left_boost_stat_is_valid and left_main_stat_is_valid :
		energy_boost_cell_manager.energy_boost_left_stat = left_stat_type
	else :
		energy_boost_cell_manager.energy_boost_left_stat = 'none' 
		
	
	if right_boost_stat_is_valid and right_main_stat_is_valid: 
		energy_boost_cell_manager.energy_boost_right_stat = right_stat_type
	else :
		energy_boost_cell_manager.energy_boost_right_stat = 'none'
	
	# for getting feedback and audio signal
	match side : 	
		'left': 
			if left_boost_stat_is_valid and left_main_stat_is_valid : 
				return true
			else :
				return false
		'right' :		
			if right_boost_stat_is_valid and right_main_stat_is_valid: 
				return true
			else :
				return false
	
	

	
func find_stat_is_valid(cell : BrainCell, stat_type : String) :
	
	if not cell : 
		return false
	
	var stat_valid : bool 
	var stat : BrainCellStat
	
	match stat_type : 
		'strength' :
			stat = cell.strength
		'intelligence' :
			stat = cell.intelligence
		'community' :
			stat = cell.community
	
	if stat.enabled == false : 
		stat_valid = false	
	elif stat.hidden == true : 
		stat_valid = false
	else :
		stat_valid = true
	
	return stat_valid
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
