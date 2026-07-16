extends Node


func _overide_exit() -> bool :
	
	if GLGameManagerBus.current_round == 1 :
		return false
	
	var collected_cells : Array[BrainCell] = GLCellManagerBus.collected_cells_refrence
	
	var total_cells = len(collected_cells)	
	
	var total_cells_with_mutation : int = 0
	for	cell : BrainCell in collected_cells : 
		if len(cell.mutations) > 0 : 
			total_cells_with_mutation += 1
		
		
	
	
	
	
	
	
	
	

	return false
