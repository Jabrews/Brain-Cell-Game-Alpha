extends Node


func _create_mutations(
	cell_1_mutations: Array[BrainCellMutation],
	cell_2_mutations: Array[BrainCellMutation]
) -> Array[BrainCellMutation]:

	var combined_mutations: Array[BrainCellMutation] = []

	combined_mutations.append_array(cell_1_mutations)
	combined_mutations.append_array(cell_2_mutations)
	
	# clear out none mutations
	for mutation : BrainCellMutation in combined_mutations : 
		if mutation.type == 'none' : 
			combined_mutations.erase(mutation)
	
	# make sure to clear duplicasted
	var unique_mutations: Array[BrainCellMutation] = []
	var used_types: Array[String] = []

	for mutation: BrainCellMutation in combined_mutations:
		if mutation.type in used_types:
			continue

		used_types.append(mutation.type)
		unique_mutations.append(mutation)

	combined_mutations = unique_mutations

	# Randomize mutation order.
	combined_mutations.shuffle()

	# Keep no more than three mutations.
	if combined_mutations.size() > 3:
		combined_mutations = combined_mutations.slice(0, 3)

	return combined_mutations
