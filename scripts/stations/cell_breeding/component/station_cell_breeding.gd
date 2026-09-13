extends Node

# panel cells
var left_main_cell: BrainCell
var right_main_cell: BrainCell
var left_boost_cell: BrainCell
var right_boost_cell: BrainCell

func set_panel_cell(seat_type: String, cell: BrainCell) -> void:
	
	match seat_type:
		"left_main":
			left_main_cell = cell

		"right_main":
			right_main_cell = cell

		"left_boost":
			left_boost_cell = cell

		"right_boost":
			right_boost_cell = cell

		_:
			push_error("Invalid seat type: ", seat_type)
			return

	GLBreedingComponetsBus.breeding_panel_state[seat_type] = cell


func get_panel_cell(seat_type: String) -> BrainCell:
	match seat_type:
		"left_main":
			return left_main_cell

		"right_main":
			return right_main_cell

		"left_boost":
			return left_boost_cell

		"right_boost":
			return right_boost_cell

		_:
			push_error("Invalid seat type: ", seat_type)
			return null
