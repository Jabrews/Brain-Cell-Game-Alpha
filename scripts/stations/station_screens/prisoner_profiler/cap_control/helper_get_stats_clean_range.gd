extends Node

func _get_clean_range(value : float) -> String:
	
	var increment = IVCellCreator.max_stat_value / 20.0
	
	var low_mid_range_min = increment * 5
	var mid_range_min = increment * 10
	var high_mid_range_min = increment * 15
	var high_range_min = increment * 20
	
	if value < low_mid_range_min:
		return "low"
	
	elif value < mid_range_min:
		return "low-mid"
	
	elif value < high_mid_range_min:
		return "middle"
	
	elif value < high_range_min:
		return "high-mid"
	
	else:
		return "high"
