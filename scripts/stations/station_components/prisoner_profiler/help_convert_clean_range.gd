extends Node

func _handle_help_convert_clean_range(clean_range : String) -> float :
	
	var increment = IVCellCreator.max_stat_value / 20.0
	
	var clean_value : float
	
	match clean_range :
		"low" :
			clean_value = increment * 0
		"low-mid" :
			clean_value = increment * 5
		"middle" :
			clean_value = increment * 10
		"high-mid" :
			clean_value = increment * 15
		"high" :
			clean_value = increment * 20
		
	# round 1 decimal point
	clean_value = round(clean_value * 10.0) / 10.0
	
	return clean_value 
