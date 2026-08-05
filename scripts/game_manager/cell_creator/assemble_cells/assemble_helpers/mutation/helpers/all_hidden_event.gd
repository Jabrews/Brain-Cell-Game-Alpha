extends Node


func _apply_all_hidden_event(
	prisoner_cells: Array[BrainCell],
	batch_mutations: Array[BrainCellMutation]
) -> Array[BrainCell]:

	var batch_mutations_available: Array[BrainCellMutation] = (
		batch_mutations.duplicate()
	)

	for cell: BrainCell in prisoner_cells:

		# Apply a real hidden mutation while any remain.
		if not batch_mutations_available.is_empty():
			var random_mutation: BrainCellMutation = (
				batch_mutations_available.pick_random()
			)

			batch_mutations_available.erase(random_mutation)

			random_mutation.hidden = true
			cell.mutations.append(random_mutation)

		# Once real mutations run out, apply fake mutations.
		else:
			var none_mutation: BrainCellMutation = (
				BrainCellMutation.new(
					"none",
					true,
					[]
				)
			)
			
			
			if GameAdminPanel.enabled :
				GameAdminPanel.updater_admin_batch_mutation.fake_mutations_applied += 1

			cell.mutations.append(none_mutation)

	return prisoner_cells
