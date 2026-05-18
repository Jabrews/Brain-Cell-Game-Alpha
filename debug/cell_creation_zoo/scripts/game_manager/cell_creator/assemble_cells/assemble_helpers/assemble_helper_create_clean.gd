extends Node

func _create(clean_range : String) -> Array[float]:
	
	var target_cell : BrainCell = GLCellManagerBus.target_cell_refrence
	
	var str_clean = create_stat(target_cell.strength, clean_range)
	var int_clean = create_stat(target_cell.intelligence, clean_range)
	var com_clean = create_stat(target_cell.community, clean_range)
	
	var clean_stats : Array[float] = [
		str_clean,
		int_clean,
		com_clean
	]
	
	return clean_stats
	


func create_stat(target_stat : float, clean_range : String) -> float:

	var random_diffrence = randi_range(0, 20)
	
	var clean_stat : float
	
	if clean_range == 'low':
		clean_stat = target_stat * .20
		
	elif clean_range == 'medium':
		clean_stat = target_stat * .40
		
	elif clean_range == 'medium-elevated':
		clean_stat = target_stat * .55
		
	elif clean_range == 'high':
		clean_stat = target_stat * .70
	
	clean_stat += random_diffrence
	
	# round to 0.0 decimal
	clean_stat = round(clean_stat * 10.0) / 10.0

	return clean_stat
