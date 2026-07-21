extends Node

func _generate_demand_mutation() -> BrainCellMutation:
	
	var good_mutations_avaible : Array[BrainCellMutation] = IVMutations.good_mutations
	var bad_mutations_avaible : Array[BrainCellMutation] = IVMutations.bad_mutations
	
	# TODO
	# fix this so we only show unlocked mutations ??
	
	var avaliable_mutations : Array[BrainCellMutation]	= []
	
	avaliable_mutations.append_array(good_mutations_avaible)
	avaliable_mutations.append_array(bad_mutations_avaible)
	
	# remove : none, seintient
	for mutation : BrainCellMutation in avaliable_mutations : 
		if mutation.type == 'none' : 
			avaliable_mutations.erase(mutation)
		
		elif mutation.type == 'sentient' : 
			avaliable_mutations.erase(mutation)
	
	
	var random_mutation : BrainCellMutation = avaliable_mutations.pick_random()
	
	return random_mutation
	
	
	
	
