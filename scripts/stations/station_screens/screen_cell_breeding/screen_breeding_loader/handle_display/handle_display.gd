extends Node

# display helper componnets
@onready var main_cell_loader : Node = $MainCellLoader
@onready var handle_boost_charge_direction : Node = $HandleBoostChargeDirection
@onready var symbol_manager : Node = $"../SeatCellLoading/SymbolManager"

# confirm btn helper
@onready var helper_handle_confirm_btn : Node = $"../HandleConfirmBtn"
@onready var helper_handle_display_new_cell : Node = $"../HandleDisplayNewCell"



func _handle_display(
	main_left_cell : BrainCell,
	main_right_cell : BrainCell,
	energy_boost_left_stat : String,
	energy_boost_right_stat: String,
	energy_boost_left_direction : String,
	energy_boost_right_direction : String,
	) -> void:
	
	# update main cell loader
	main_cell_loader._handle_recieve_main_cells(
		main_left_cell,
		main_right_cell,
	)
	
	# boost apply any changes in stat visuals
	handle_boost_charge_direction._handle_recieve_energy_boost(
		main_left_cell,
		main_right_cell,
		energy_boost_left_stat,
		energy_boost_right_stat,
		energy_boost_left_direction,
		energy_boost_right_direction,
	)
	
	# create copies of main cells	
	var copy_main_cell_left: BrainCell = copy_cell(main_left_cell)
	var copy_main_cell_right: BrainCell = copy_cell(main_right_cell)
	
	# apply any change via charge boost to cells	
	# or it will just return exact copy if not valid
	# this will get to symbols
	copy_main_cell_left = apply_charge_boost_to_copy(
		copy_main_cell_left,
		energy_boost_left_stat,
		energy_boost_left_direction
	)
	
	copy_main_cell_right = apply_charge_boost_to_copy(
		copy_main_cell_right,
		energy_boost_right_stat,
		energy_boost_right_direction
	)
	
	# update symbols
	update_symbols(copy_main_cell_left, copy_main_cell_right)
	
	
	# dealing with waiting to see results
	var has_both_cells = main_left_cell and main_right_cell
	helper_handle_confirm_btn._cells_detcted(has_both_cells)
	
	# dealing with new cell display
	if has_both_cells : 
		helper_handle_display_new_cell._display_new_cell(copy_main_cell_left, copy_main_cell_right)
	else : 
		helper_handle_display_new_cell._reset()


func copy_cell(cell : BrainCell) -> BrainCell:
	if not cell:
		return null
	
	return cell.copy()


func apply_charge_boost_to_copy(
	cell : BrainCell,
	energy_boost_stat : String,
	energy_boost_direction : String,
	) -> BrainCell:
	
	if not cell:
		return null
	
	return GAMECellBreeder.increase_cell_charge_helper._get_increased(
		energy_boost_stat,
		energy_boost_direction,
		cell
	)


func update_symbols(main_left_cell : BrainCell, main_right_cell : BrainCell) -> void:
	if main_left_cell:
		symbol_manager.check_for_checkmarks("left", main_left_cell)
	
	if main_right_cell:
		symbol_manager.check_for_checkmarks("right", main_right_cell)
	
	if main_left_cell and main_right_cell:
		symbol_manager.check_for_symbols(main_left_cell, main_right_cell)
	
	if not main_left_cell or not main_right_cell:
		symbol_manager.hide_symbols()
		
	if not main_left_cell : 
		symbol_manager.hide_checkmarks('left', main_left_cell)
	
	if not  main_right_cell: 
		symbol_manager.hide_checkmarks('right', main_right_cell)
		
		
