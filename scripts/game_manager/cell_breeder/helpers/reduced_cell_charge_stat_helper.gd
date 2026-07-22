extends Node


func _get_reduced(selected_stat : String, boost_cell : BrainCell) -> BrainCellStat:
	
	var cell : BrainCell = boost_cell.copy()
	
	var old_stat: BrainCellStat = cell.get(selected_stat)
	
	var new_clean_value: float = old_stat.value - (IVCellCreator.max_stat_value * .15)
	var new_defect_value: float = old_stat.defect + (IVCellCreator.max_stat_value * .15)
	
	new_clean_value = clampf(new_clean_value, 0.0, IVCellCreator.max_stat_value)
	new_defect_value = clampf(new_defect_value, 0.0, IVCellCreator.max_stat_value)
	
	var reduced_stat := BrainCellStat.new(
		old_stat.type,
		old_stat.enabled,
		new_clean_value,
		new_defect_value,
		old_stat.hidden
	)
	return reduced_stat

func _check_death(selected_stat : String , boost_cell : BrainCell) :
	
	if boost_cell == null:
		return false
	
	var cell: BrainCell = boost_cell.copy()
	var old_stat: BrainCellStat = cell.get(selected_stat)

	if not old_stat : 
		return false

	# if we are at 1.0 kill
	if old_stat.value <= 20.0 : 
		return true 
	
