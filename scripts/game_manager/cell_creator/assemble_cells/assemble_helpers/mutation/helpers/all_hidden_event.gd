extends Node

func _apply_all_hidden_event(prisoner_cells : Array[BrainCell], batch_mutations : Array[BrainCellMutation]) :
	
	var batch_mutations_avaible = batch_mutations.duplicate()

	for cell : BrainCell in prisoner_cells :
		
		# apply mutation to cell
		if not batch_mutations_avaible.is_empty() :
			
			# pick random mutation
			var random_mutation : BrainCellMutation = batch_mutations_avaible.pick_random()
			# erase from avaible
			batch_mutations_avaible.erase(random_mutation)
			# set hidden to true
			random_mutation.hidden = true
			
			# add mutation
			cell.mutations.append(batch_mutations_avaible[0])
			
			break
		
		# if out of mutation. apply fake mutation
		else : 
			var none_mutation : BrainCellMutation = BrainCellMutation.new("none", true, [])
			
			# add mutation
			cell.mutations.append(none_mutation)
			
			break
