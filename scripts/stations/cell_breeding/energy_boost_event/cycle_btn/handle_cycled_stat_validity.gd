extends Node

# cell manager component
@onready var energy_boost_cell_manager : Node = $"../../../MainCellManager/EnergyBoostCellManager"

# parent cycle event
@onready var parent_handle_cycle_btn_pressed : Node = $".."


var stats : Array[String] = ['community', 'intelligence', 'strength']

func _check_stats_validity() :
	
	# get cells and index (index from parent cycle)
	var energy_boost_left_cell : BrainCell = energy_boost_cell_manager.energy_boost_left_cell
	var energy_boost_right_cell : BrainCell = energy_boost_cell_manager.energy_boost_right_cell
	var left_index : int = parent_handle_cycle_btn_pressed.left_index 
	var right_index : int = parent_handle_cycle_btn_pressed.right_index 
	
	# get stat
	var left_stat_type = stats[left_index]
	var right_stat_type = stats[right_index]
	
	# see if its disabled or hidden (not valid)
	var left_stat_is_valid = find_stat_is_valid(energy_boost_left_cell, left_stat_type)
	var right_stat_is_valid = find_stat_is_valid(energy_boost_right_cell, right_stat_type)
	
	# none-invalid stat-valid
	if left_stat_is_valid :
		energy_boost_cell_manager.energy_boost_left_stat = left_stat_type
	else :
		energy_boost_cell_manager.energy_boost_left_stat = 'none' 
		
	
	if right_stat_is_valid : 
		energy_boost_cell_manager.energy_boost_right_stat = right_stat_type
	else :
		energy_boost_cell_manager.energy_boost_right_stat = 'none'

	
func find_stat_is_valid(cell : BrainCell, stat_type : String) :
	
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
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
