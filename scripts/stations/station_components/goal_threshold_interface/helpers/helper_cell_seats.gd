extends Node

# components
@onready var s_invalid : AudioStreamPlayer3D = $"../Audio/InvalidSound"
@onready var cell_seat_lights : Array[Node3D] = [
	$"../CellSeats/Seats/CellSeat1/CellLight",
	$"../CellSeats/Seats/CellSeat2/CellLight",
	$"../CellSeats/Seats/CellSeat3/CellLight",
	$"../CellSeats/Seats/CellSeat4/CellLight",
]
# helper components
@onready var handle_cycle_stat_btn : Node = $"../HandleCycleStatBtn"

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
		
	
	load_cell_lights()
		
		
func verify_prerequisite_seats_filled(cell_seat_num : int) -> bool:
	
	var curr_check_num : int = cell_seat_num - 1
	
	while curr_check_num >= 1:
		
		if cell_seats[curr_check_num] == null:
			return false
		
		curr_check_num -= 1
	
	return true


# go through each seat and set light
func load_cell_lights() -> void:
	
	var curr_check_num : int = 1
	
	while curr_check_num != 5:
		
		var curr_cell : BrainCell = cell_seats[curr_check_num]
		
		# cell is on spot -> green
		if curr_cell:
			cell_seat_lights[curr_check_num - 1]._switch_light_state("seat_filled")
		
		else:
			
			# seat 1 is always available
			if curr_check_num == 1:
				cell_seat_lights[curr_check_num - 1]._switch_light_state("seat_unfilled")
			
			# check if all seats before this one are filled
			elif verify_prerequisite_seats_filled(curr_check_num):
				cell_seat_lights[curr_check_num - 1]._switch_light_state("seat_unfilled")
			
			else:
				cell_seat_lights[curr_check_num - 1]._switch_light_state("inactive")
		
		curr_check_num += 1


		
		
	
	
	
	
	
	
	
	
	
	
	
	
	
