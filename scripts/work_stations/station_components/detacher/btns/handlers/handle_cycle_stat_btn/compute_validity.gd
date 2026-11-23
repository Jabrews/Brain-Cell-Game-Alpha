extends Node


func _compute(loaded_cell : BrainCell, selected_stat : String) :
	
	var cell_stat : BrainCellStat = loaded_cell.get_stat(selected_stat)
	
	var stat_valid : bool = true 
	
	if not cell_stat.enabled : 
		stat_valid = false 
	
	if cell_stat.hidden : 
		stat_valid = false 
	
	return stat_valid
	
	
