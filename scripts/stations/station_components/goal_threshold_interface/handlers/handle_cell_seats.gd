extends Node

# components
@onready var s_invalid : AudioStreamPlayer3D = $"../Audio/InvalidSound"

# helper components
@onready var handle_cycle_stat_btn : Node = $"../HandleCycleStatBtn"
# parent station
@onready var parent_station_threshold_interface : Node3D = $".."

var cell_seats : Dictionary[int, BrainCell] = {
	1 : null,
	2 : null,
	3 : null,
	4 : null,
}

func _handle_cell_seat_changed(cell_seat_num : int, cell : BrainCell) :
	
	# only check prerequisites when LOADING a cell
	if cell:
		
		# dont check cell 1 pre-requisets
		if cell_seat_num != 1 :
			
			var prerequisite_seats_met : bool = verify_prerequisite_seats_filled(
				cell_seat_num
			)
			
			if not prerequisite_seats_met:
				s_invalid.play()
				return 
			
			cell_seats[cell_seat_num] = cell
		
		# if cell 1
		else : 
			cell_seats[cell_seat_num] = cell
			
		
	# if removed dont care about pre-requeisets
	else :
		cell_seats[cell_seat_num] = cell
	
	# inital update screen selected stat screen
	if cell : 
		handle_cycle_stat_btn._toggle_cell_added(true, cell_seat_num)
	else : 
		handle_cycle_stat_btn._toggle_cell_added(false, cell_seat_num)
		
	
	# REFRESH let parent station know
	parent_station_threshold_interface._handle_cell_seats_changed()
	
		
func verify_prerequisite_seats_filled(cell_seat_num : int) -> bool:
	
	var curr_check_num : int = cell_seat_num - 1
	
	while curr_check_num >= 1:
		
		if cell_seats[curr_check_num] == null:
			return false
		
		curr_check_num -= 1
	
	return true
