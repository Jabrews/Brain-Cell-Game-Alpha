extends Node

# display helper componnets
@onready var main_cell_loader : Node = $MainCellLoader
@onready var preview_charge_direction : Node = $PreviewChargeDirection
@onready var symbol_manager : Node = $"../SeatCellLoading/SymbolManager"

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
	
	# update symbols
	update_symbols(main_left_cell, main_right_cell)
	

	

func update_symbols(main_left_cell : BrainCell, main_right_cell : BrainCell) :
	if main_left_cell : 	
		symbol_manager.check_for_checkmarks('left', main_left_cell)
	
	if main_right_cell : 	
		symbol_manager.check_for_checkmarks('right', main_right_cell)
	
	if main_left_cell and main_right_cell :
		symbol_manager.check_for_symbols(main_left_cell, main_right_cell)
	
	if not main_left_cell or not main_right_cell : 
		symbol_manager.hide_symbols()
	
	
