extends Node

# parent station component
@onready var parent_station_interface : Node3D = $".."

# light components
@onready var cell_seat_lights : Array[Node3D] = [
	$"../CellSeats/Seats/CellSeat1/CellLight",
	$"../CellSeats/Seats/CellSeat2/CellLight",
	$"../CellSeats/Seats/CellSeat3/CellLight",
	$"../CellSeats/Seats/CellSeat4/CellLight"
]


# go through each seat and set light
func _refresh(cell_seats : Dictionary[int, BrainCell],cell_selected_stats : Dictionary[int, String]) -> void:
	
	var strength_dissolve_cell : BrainCell = parent_station_interface.strength_dissolve_cell
	var intelligence_dissolve_cell : BrainCell = parent_station_interface.intelligence_dissolve_cell
	var community_dissolve_cell : BrainCell = parent_station_interface.community_dissolve_cell
	
	var curr_check_num : int = 1
	
	while curr_check_num != 5:
		
		var curr_cell : BrainCell = cell_seats[curr_check_num]
		var selected_stat : String = cell_selected_stats[curr_check_num]
		var cell_light : Node3D = cell_seat_lights[curr_check_num - 1]
		
		
		## CELL EXISTS
		if curr_cell:
			
			# currently being dissolved -> flashing green
			if (
				curr_cell == strength_dissolve_cell or
				curr_cell == intelligence_dissolve_cell or
				curr_cell == community_dissolve_cell
			):
				cell_light._switch_light_state("seat_dissolving")
			
			
			# selected stat has already been exhausted -> flashing yellow
			elif _is_selected_stat_finished(
				curr_cell,
				selected_stat
			):
				cell_light._switch_light_state("seat_finished")
			
			
			# cell exists but isn't currently dissolving
			else:
				cell_light._switch_light_state("seat_filled")
		
		## EMPTY SEAT
		else:
			
			# seat 1 is always available
			if curr_check_num == 1:
				cell_light._switch_light_state("seat_unfilled")
			
			# previous seats filled -> available
			elif verify_prerequisite_seats_filled(curr_check_num, cell_seats):
				cell_light._switch_light_state("seat_unfilled")
			
			else:
				cell_light._switch_light_state("inactive")
		
		
		curr_check_num += 1

func _is_selected_stat_finished(cell : BrainCell, selected_stat : String) -> bool:
	
	match selected_stat:
		
		"strength":
			return not cell.strength.enabled
		
		"intelligence":
			return not cell.intelligence.enabled
		
		"community":
			return not cell.community.enabled
		
		"all":
			# finished only once the cell has no usable stats left
			return (
				not cell.strength.enabled and
				not cell.intelligence.enabled and
				not cell.community.enabled
			)
		
		"none":
			return false
		
		_:
			return false

func verify_prerequisite_seats_filled(cell_seat_num : int, cell_seats : Dictionary[int, BrainCell]) -> bool:
	
	var curr_check_num : int = cell_seat_num - 1
	
	while curr_check_num >= 1:
		
		if cell_seats[curr_check_num] == null:
			return false
		
		curr_check_num -= 1
	
	return true
