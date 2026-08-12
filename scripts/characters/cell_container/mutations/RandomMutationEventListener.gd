extends Node3D

class_name RandomMutationEventListener

@onready var parent_cell_container : CharacterBody3D = $"../../.."

var designated_mutation_event: MutationEvent


func _toggle_mutation_event_situation_increase(toggle_value: bool, mutation_type: String, mutation_event_name: String) -> void:
	
	var brain_cell: BrainCell = parent_cell_container.designated_brain_cell

	if brain_cell == null:
		push_error("Parent cell has no designated BrainCell.")
		return

	for mutation: BrainCellMutation in brain_cell.mutations:
		if mutation.type != mutation_type:
			continue

		for mutation_event: MutationEvent in mutation.mutation_events:
			if mutation_event.event_name != mutation_event_name:
				continue

			if toggle_value:
				mutation_event.trigger_chance += 1
			else:
				mutation_event.trigger_chance -= 1
			
			mutation_event.trigger_chance = clampi(mutation_event.trigger_chance, 0, 1)
			

			GLCellManagerBus.emit_signal(
				"collected_cell_changed",
				brain_cell
			)

			return

	push_error(
		"Mutation event not found: %s / %s"
		% [mutation_type, mutation_event_name]
	)
