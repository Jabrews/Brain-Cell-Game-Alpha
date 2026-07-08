extends Node


func _get_reduced(selected_stat : String, boost_cell : BrainCell) -> BrainCellStat:
	
	var cell : BrainCell = boost_cell.copy()
	
	var old_stat: BrainCellStat = cell.get(selected_stat)
	
	var new_clean_value: float = old_stat.value - (IVCellCreator.max_stat_value * .15)
	var new_defect_value: float = old_stat.defect + (IVCellCreator.max_stat_value * .15)
	
	var reduced_stat := BrainCellStat.new(
		old_stat.type,
		old_stat.enabled,
		new_clean_value,
		new_defect_value,
		old_stat.hidden
	)
	return reduced_stat
