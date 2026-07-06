extends Node

# display helper componnets
@onready var main_cell_loader : Node = $MainCellLoader

func _handle_display(
	main_left_cell : BrainCell, 
	main_right_cell : BrainCell,
	energy_boost_left_stat : String, 
	energy_boost_right_stat: String, 
	energy_boost_left_direction : String, 
	energy_boost_right_direction : String,
	) :
	
	# update main cell loader
	main_cell_loader._handle_recieve_main_cells(
		main_left_cell,
		main_right_cell,
		
		
	)
	
	# TODO : update energy boost if possible
	
	# TODO : update arrows if possible (NEED BOTH CELLS)
	
