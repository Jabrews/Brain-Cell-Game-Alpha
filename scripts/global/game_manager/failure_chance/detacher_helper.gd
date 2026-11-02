extends Node

@export var defect_percant_increase : Dictionary[int, float] = {
	1 : 50.0,
	2 : 51.0,
}

func _get_stat_failure_chance(loaded_cell : BrainCell, selected_stat : String) :
	
	var cell_stat : BrainCellStat = loaded_cell.get_stat(selected_stat)
	
	var max_stat: float = IVCellCreator.max_stat_value
	
	var defect_percent: float = (cell_stat.defect / max_stat) * 100
	
	var chance_increase: float = 0.0
	
	# 50% - 75% defect
	if defect_percent >= 20.0 and defect_percent < 75.0:
		chance_increase = defect_percant_increase.get(1)
	
	# 75%+ defect
	elif defect_percent >= 75.0:
		chance_increase = defect_percant_increase.get(2)
	
	return chance_increase
	
