extends Node

func _evaluate(brain_cell : BrainCell, evaluate_mutation : BrainCellMutation) :
	
	var found_mutation : bool = false
	
	for mutation : BrainCellMutation in brain_cell.mutations : 
		if mutation.type == evaluate_mutation.type :
			found_mutation = true
	
	return found_mutation
