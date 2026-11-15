extends Node

# components
@onready var parent_defect_decreaser : Node3D = $"../.."


func _compute(loaded_cell : BrainCell): 
		
	if not loaded_cell : 		
		push_error('attempted to create reduction context without cell')
		return null
		
	var stats : Array[BrainCellStat] = loaded_cell._get_stats()
	
	var valid_stats : Array[BrainCellStat] = []
	var valid_stat_found : bool = false
	
	for stat : BrainCellStat in stats : 
		
		
		if stat.defect > 0 : 
			
			if not stat.hidden : 			
				valid_stat_found = true
				valid_stats.append(stat)
		
	
	return DefectReductionContext.new(loaded_cell, valid_stat_found, valid_stats)
	
	
	
