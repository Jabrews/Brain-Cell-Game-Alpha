extends Node


func _get_cell(prisoner_cells : Array[BrainCell]) :
	
	# score =  total clean stat value - (total defect value * 0.5)
			
	var best_cell = {
		'cell' : null,
		'score' : 0,
	}
	
	for cell : BrainCell in prisoner_cells : 
		var total_clean = cell.strength.value + cell.intelligence.value + cell.community.value
		var total_defect = (cell.strength.defect + cell.intelligence.defect + cell.community.defect) * 0.5
		
		var score = total_clean - total_defect
		
		# for first cell in list
		if best_cell['cell'] == null : 
			best_cell['cell'] = cell
			best_cell['score'] = score
			return
			
		# see if score is better
		if best_cell['score'] < score :
			best_cell['cell'] = cell
			best_cell['score'] = score
			return
		
	return best_cell['cell']
			
