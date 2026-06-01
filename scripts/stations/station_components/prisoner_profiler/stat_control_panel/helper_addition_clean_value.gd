extends Node

func _handle_get_add_value(current_stat_value : float, clean_range : String) -> int:
	
	var increment = IVCellCreator.max_stat_value / 20.0
	var range_size = increment * 5.0
	var step_size = range_size / 5.0
	
	var clean_range_min : float
	
	match clean_range:
		"low":
			clean_range_min = increment * 0

		"low-mid":
			clean_range_min = increment * 5

		"middle":
			clean_range_min = increment * 10

		"high-mid":
			clean_range_min = increment * 15

		"high":
			clean_range_min = increment * 20

		_:
			push_error("invalid clean range")
			return 0
	
	var value_inside_range = current_stat_value - clean_range_min
	var step_index = floor(value_inside_range / step_size)
	
	step_index = clamp(step_index, 0, 4)
	
	return int((step_index + 1) * 1)
