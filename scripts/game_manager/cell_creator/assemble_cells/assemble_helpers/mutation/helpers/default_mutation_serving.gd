extends Node


func _apply_default_mutation_serving(prisoner_cells: Array[BrainCell], batch_mutations: Array[BrainCellMutation], energy_phase: int) -> Array[BrainCell]:

	var batch_mutations_available: Array[BrainCellMutation] = batch_mutations.duplicate()

	# Cells that can later receive fake mutations.
	var cells_without_mutation: Array[BrainCell] = prisoner_cells.duplicate()

	var hidden_mutation_was_served: bool = false

	# apply muitations for cell
	for cell: BrainCell in prisoner_cells:

		if batch_mutations_available.is_empty():
			break

		# Pick and remove a random mutation.
		var random_mutation: BrainCellMutation = batch_mutations_available.pick_random()
		batch_mutations_available.erase(random_mutation)

		# Decide whether the mutation is hidden.
		var chance_to_hide_mutation: int = IVMutations.chance_to_hide_mutation
		var random_number: int = randi_range(1, 100)

		if random_number <= chance_to_hide_mutation:
			random_mutation.hidden = true
			hidden_mutation_was_served = true
		else:
			random_mutation.hidden = false

		# Add the selected mutation.
		cell.mutations.append(random_mutation)
		cells_without_mutation.erase(cell)

	# fake mutations

	# Fake mutations are only needed when a real mutation
	# was hidden from the player.
	if not hidden_mutation_was_served:
		return prisoner_cells

	if cells_without_mutation.is_empty():
		return prisoner_cells

	var min_fake_mutations: int = (
		IVMutations.min_fake_mutations_per_batch
	)

	var max_fake_mutations: int = (
		IVMutations.max_fake_mutations_per_batch
	)

	if min_fake_mutations < 0:
		push_error("Minimum fake mutations cannot be below 0.")
		min_fake_mutations = 0

	if min_fake_mutations > max_fake_mutations:
		push_error(
			"Minimum fake mutations cannot be above maximum."
		)
		min_fake_mutations = max_fake_mutations

	var fake_mutation_amount: int = min_fake_mutations

	var increment_chance: int = get_energy_phase_chance(energy_phase)

	# Roll once for every possible fake mutation
	# above the minimum amount.
	var extra_fake_slots: int = (
		max_fake_mutations - min_fake_mutations
	)

	for slot: int in range(extra_fake_slots):
		var random_number: int = randi_range(1, 100)

		if random_number <= increment_chance:
			fake_mutation_amount += 1

	# Do not create more fake mutations than there are cells.
	if fake_mutation_amount > cells_without_mutation.size():
		fake_mutation_amount = cells_without_mutation.size()

	for amount: int in range(fake_mutation_amount):
		var selected_cell: BrainCell = (
			cells_without_mutation.pick_random()
		)

		cells_without_mutation.erase(selected_cell)

		var none_mutation: BrainCellMutation = BrainCellMutation.new("none", true, [] )

		selected_cell.mutations.append(none_mutation)

	return prisoner_cells


func get_energy_phase_chance(
	energy_phase: int
) -> int:
	match energy_phase:
		0:
			return 25

		1:
			return 50

		2:
			return 75

		_:
			push_error(
				"Invalid mutation energy phase: %s"
				% energy_phase
			)
			return 0
