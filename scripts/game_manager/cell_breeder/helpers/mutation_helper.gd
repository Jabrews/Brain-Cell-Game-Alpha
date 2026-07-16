extends Node


func _create_mutations(
	cell_1_mutations: Array[BrainCellMutation],
	cell_2_mutations: Array[BrainCellMutation]
) -> Array[BrainCellMutation]:

	var combined_mutations: Array[BrainCellMutation] = []

	combined_mutations.append_array(cell_1_mutations)
	combined_mutations.append_array(cell_2_mutations)

	# Randomize mutation order.
	combined_mutations.shuffle()

	# Keep no more than three mutations.
	if combined_mutations.size() > 3:
		combined_mutations = combined_mutations.slice(0, 3)

	return combined_mutations
