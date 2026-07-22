extends Node


func _get_reduced(selected_stat: String, selected_direction : String, boost_cell: BrainCell) -> BrainCell:
	
	if boost_cell == null:
		return null
	
	if selected_stat == "none" or selected_direction == 'none':
		return boost_cell
	
	var cell: BrainCell = boost_cell.copy()
	var old_stat: BrainCellStat = cell.get(selected_stat)
	
	# if we are at 1.0 kill
	if old_stat.value <= 20.0 : 
		return null
	
	
	if old_stat == null:
		push_error("Invalid selected_stat: " + selected_stat)
		return cell
	
	var change_amount: float = IVCellCreator.max_stat_value * 0.15
	
	var new_clean_value: float = old_stat.value - change_amount
	var new_defect_value: float = old_stat.defect + change_amount
	
	new_clean_value = clampf(new_clean_value, 0.0, IVCellCreator.max_stat_value)
	new_defect_value = clampf(new_defect_value, 0.0, IVCellCreator.max_stat_value)
	
	var reduced_stat := BrainCellStat.new(
		old_stat.type,
		old_stat.enabled,
		new_clean_value,
		new_defect_value,
		old_stat.hidden
	)
	
	cell.set(selected_stat, reduced_stat)
	
	return cell
