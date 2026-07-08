extends Node


func _get_increased(selected_stat: String, selected_direction: String, main_cell: BrainCell) -> BrainCell:
	
	
	# only apply increase if both vars are filled
	if selected_stat == "none" or selected_direction == "none":
		return main_cell
	
	var selected_brain_cell_stat: BrainCellStat
	
	match selected_stat:
		"strength":
			selected_brain_cell_stat = main_cell.strength
		"intelligence":
			selected_brain_cell_stat = main_cell.intelligence
		"community":
			selected_brain_cell_stat = main_cell.community
		_:
			push_error("Invalid selected_stat: " + selected_stat)
			return main_cell
	
	var direction_change: int
	
	match selected_direction:
		"increase":
			direction_change = 1
		"decrease":
			direction_change = -1
		_:
			push_error("Invalid selected_direction: " + selected_direction)
			return main_cell
	
	# increase/decrease by 20% of max stat value
	var change_amount: float = IVCellCreator.max_stat_value * 0.15
	
	var new_stat_value: float = selected_brain_cell_stat.value + float(direction_change) * change_amount
	
	new_stat_value = clampf(
		new_stat_value,
		0.0,
		IVCellCreator.max_stat_value
	)
	
	selected_brain_cell_stat.value = new_stat_value
	
	return main_cell
