extends Node

# components
@onready var parent_station : Node3D = $".."
@onready var handle_display_ui : Node = $"../HandleDisplayUi"

func _handle() :  
	finale_breeding_request()

func finale_breeding_request() :
	
	var main_left_cell : BrainCell = parent_station.left_main_cell
	var main_right_cell : BrainCell = parent_station.right_main_cell
	var boost_left_cell : BrainCell = parent_station.left_boost_cell
	var boost_right_cell : BrainCell = parent_station.right_boost_cell
	#var boost_left_stat : String = energy_boost_cell_manager.energy_boost_left_stat
	#var boost_right_stat : String = energy_boost_cell_manager.energy_boost_right_stat
	#var boost_left_direction : String = energy_boost_cell_manager.energy_boost_left_direction
	#var boost_right_direction : String = energy_boost_cell_manager.energy_boost_right_direction
	
	GLCellBreederBus.emit_signal('player_breeded_cells', 
	main_left_cell ,
	main_right_cell ,
	boost_left_cell ,
	boost_right_cell ,
	'', # boost
	'',
	'', # direction
	'',
	)
	
	# close
	handle_display_ui._toggle_display(false)
	
	# reset ui cells
	for key in GLBreedingComponetsBus.breeding_ui_state : 
		GLBreedingComponetsBus.breeding_ui_state[key] = null
	
	
	
