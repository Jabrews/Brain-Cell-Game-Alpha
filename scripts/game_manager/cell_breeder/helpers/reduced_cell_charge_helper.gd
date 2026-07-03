extends Node


func _get_reduced(cell: BrainCell, selected_stat: String) -> Array:
	var old_stat: BrainCellStat = cell.get(selected_stat)
	
	if old_stat == null:
		push_error("Invalid selected_stat: " + selected_stat)
		return []
	
	var new_clean_value: float = old_stat.value - (old_stat.value * .50)
	var new_defect_value: float = old_stat.defect + (old_stat.defect * .50)
	
	var reduced_stat := BrainCellStat.new(
		old_stat.type,
		old_stat.enabled,
		new_clean_value,
		new_defect_value,
		old_stat.hidden
	)
	
	var preview_cell: BrainCell = cell.copy()
	preview_cell.set(selected_stat, reduced_stat)
	
	return [reduced_stat, preview_cell]
