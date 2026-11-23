extends Node


func _verify(
	cell_mutations: Array[BrainCellMutation],
	events: Array[MutationEvent]
) -> Array[MutationEvent]:

	var verified_events: Array[MutationEvent] = []

	for mutation_event: MutationEvent in events:
		var found_corresponding_mutation: bool = false

		for mutation: BrainCellMutation in cell_mutations:
			if mutation.type == mutation_event.mutation_name:
				found_corresponding_mutation = true
				break

		if found_corresponding_mutation:
			verified_events.append(mutation_event)

	return verified_events
