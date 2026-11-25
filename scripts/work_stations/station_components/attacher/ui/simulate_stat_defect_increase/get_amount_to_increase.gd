extends Node

var stats: Array[String] = ['strength', 'intelligence', 'community']

func _get_amount(old_cell : BrainCell, new_cell : BrainCell) -> Dictionary[String, int] : 
	
	var defect_amount_to_increase: Dictionary[String, int] = {
		'strength': 0,
		'intelligence': 0,
		'community': 0,
	}
	
	for curr_index in range(stats.size()):

		# get data
		var stat_type: String = stats[curr_index]
		var old_stat: BrainCellStat = old_cell.get_stat(stat_type)
		var new_stat: BrainCellStat = new_cell.get_stat(stat_type)
		
		
		# calculate defect difference
		var defect_increase: int = int(new_stat.defect - old_stat.defect)
		
		# store amount to animate
		defect_amount_to_increase[stat_type] = maxi(defect_increase, 0)
	
	
	return defect_amount_to_increase
	
