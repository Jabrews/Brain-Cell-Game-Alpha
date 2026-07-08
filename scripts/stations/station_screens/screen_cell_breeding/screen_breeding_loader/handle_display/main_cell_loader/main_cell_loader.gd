extends Node

# display componnets 
@onready var left_loaded_cell_stat_diplay : Control = $"../../SeatCellLoading/LeftLoader/LoadedCellDisplay"
@onready var left_no_cell_loaded_label : Label = $"../../SeatCellLoading/LeftLoader/NoCellLoaded"
@onready var right_loaded_cell_stat_diplay : Control = $"../../SeatCellLoading/RightLoader/LoadedCellDisplay"
@onready var right_no_cell_loaded_label : Label = $"../../SeatCellLoading/RightLoader/NoCellLoaded"

# reset helper componnets
@onready var reset_stat_left_loader : Node = $ResetStatLeftLoader
@onready var reset_stat_right_loader : Node =$ResetStatRightLoader

# load cell helper componnets
@onready var display_stat_left_loader : Node = $DisplayStatLeftLoader
@onready var display_stat_right_loader : Node = $DisplayStatRightLoader



func _handle_recieve_main_cells(main_left_cell : BrainCell, main_right_cell : BrainCell) :
	
	var has_left_cell : bool = main_left_cell != null
	var has_right_cell : bool = main_right_cell != null
	
	left_loaded_cell_stat_diplay.visible = has_left_cell
	left_no_cell_loaded_label.visible = !has_left_cell
	
	right_loaded_cell_stat_diplay.visible = has_right_cell
	right_no_cell_loaded_label.visible = !has_right_cell
	
	
	# reset both stat loader displays
	reset_stat_left_loader._reset()
	reset_stat_right_loader._reset()
	
	if has_left_cell : 	
		display_stat_left_loader._display_cell(main_left_cell)
	
	if has_right_cell : 
		display_stat_right_loader._display_cell(main_right_cell)
	
	
	
	
	
