extends Area3D

@onready var helper_cell_seats : Node = $"../../../../HelperCellSeats"

@export var cell_seat_num : int = 1


func _ready() -> void:
	connect("body_entered", _handle_body_entered)
	connect("body_exited", _handle_body_exited)


func _handle_body_entered(body : CharacterBody3D) -> void:
	if body.is_in_group("brain_cell_container"):
		
		# get corresponding cell seat
		var corresponding_cell : BrainCell = helper_cell_seats.cell_seats[cell_seat_num]
		
		# if cell already exists, ignore
		if corresponding_cell:
			return
		
		var body_cell : BrainCell = body.designated_brain_cell
		
		helper_cell_seats._handle_cell_seat_changed(
			cell_seat_num,
			body_cell
		)


func _handle_body_exited(body : CharacterBody3D) -> void:
	if body.is_in_group("brain_cell_container"):
		
		# get corresponding cell seat
		var corresponding_cell : BrainCell = helper_cell_seats.cell_seats[cell_seat_num]
		
		# make sure the cell that left is the one previously on seat
		var body_cell : BrainCell = body.designated_brain_cell
		
		if corresponding_cell:
			if body_cell.name != corresponding_cell.name:
				return
		
		helper_cell_seats._handle_cell_seat_changed(
			cell_seat_num,
			null
		)
