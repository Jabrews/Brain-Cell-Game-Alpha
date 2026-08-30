extends Node

# display component
@onready var stat_display : Control = $"../../StatDisplay"
@onready var no_cell_dsiplay : Control = $"../../NoCell"

# reset helper componnet
@onready var reset_stat_display : Node = $ResetStatDisplay

# display stat component
@onready var display_stat_display : Node = $DisplayStatDisplay


func _handle_recieve_energy_seat_cell(energy_seat_cell : BrainCell) : 
	
	var has_energy_seat_cell : bool = energy_seat_cell != null
	
	stat_display.visible = has_energy_seat_cell
	no_cell_dsiplay.visible = !has_energy_seat_cell
	
	reset_stat_display._reset()
	
	if energy_seat_cell : 
		display_stat_display._display_cell(energy_seat_cell)
		
		
	
	
	
	
