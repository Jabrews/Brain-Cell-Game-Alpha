extends Node

# cell manager
@onready var main_cell_manager : Node = $"../MainCellManager"
@onready var energy_boost_cell_manager : Node =$"../MainCellManager/EnergyBoostCellManager"


# finale breeding function called from screen_cell_breeding_loader
func _handle_final_breeding_request() :
	var main_left_cell : BrainCell = main_cell_manager.main_left_cell
	var main_right_cell : BrainCell = main_cell_manager.main_right_cell
	var boost_left_cell : BrainCell = energy_boost_cell_manager.energy_boost_left_cell
	var boost_right_cell : BrainCell = energy_boost_cell_manager.energy_boost_right_cell
	var boost_left_stat : String = energy_boost_cell_manager.energy_boost_left_stat
	var boost_right_stat : String = energy_boost_cell_manager.energy_boost_right_stat
	var boost_left_direction : String = energy_boost_cell_manager.energy_boost_left_direction
	var boost_right_direction : String = energy_boost_cell_manager.energy_boost_right_direction
	
	GLCellBreederBus.emit_signal('player_breeded_cells', 
	main_left_cell ,
	main_right_cell ,
	boost_left_cell ,
	boost_right_cell ,
	boost_left_stat ,
	boost_right_stat ,
	boost_left_direction ,
	boost_right_direction ,
	)
	
