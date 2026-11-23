extends Node


var available_mutations: Array[BrainCellMutation] = []


func _ready() -> void:
	GLCellManagerBus.connect('collected_cell_created', _handle_collected_cell_created)

	_fill_available_mutations()


func _get_mutations(
	energy_phase: int
) -> Array[BrainCellMutation]:
	var selected_mutations: Array[BrainCellMutation] = []

	if available_mutations.is_empty():
		return selected_mutations

	var min_amount: int = IVMutations.min_mutations_per_batch
	var max_amount: int = IVMutations.max_mutations_per_batch

	if max_amount <= 0:
		return selected_mutations

	if min_amount < 0:
		push_error("Minimum mutations cannot be below 0.")
		min_amount = 0

	if min_amount > max_amount:
		push_error("Minimum mutations cannot be above maximum.")
		min_amount = max_amount

	var mutation_amount: int = min_amount
	var extra_mutation_chance: int = get_energy_phase_chance(energy_phase)
	var extra_slots: int = max_amount - min_amount

	for _slot: int in range(extra_slots):
		if randi_range(1, 100) <= extra_mutation_chance:
			mutation_amount += 1

	# Always select at least one mutation when mutations are available.
	if mutation_amount == 0:
		mutation_amount = 1

	mutation_amount = mini(mutation_amount, available_mutations.size())

	var mutation_pool: Array[BrainCellMutation] = available_mutations.duplicate()

	for _amount: int in range(mutation_amount):
		if mutation_pool.is_empty():
			break

		var selected_mutation: BrainCellMutation = mutation_pool.pick_random()
		selected_mutations.append(selected_mutation)

		# Prevent duplicate mutation types in this batch.
		for index: int in range(mutation_pool.size() - 1, -1, -1):
			if mutation_pool[index].type == selected_mutation.type:
				mutation_pool.remove_at(index)

	return selected_mutations


func get_energy_phase_chance(energy_phase: int) -> int:
	match energy_phase:
		0:
			return 25
		1:
			return 50
		2:
			return 75
		_:
			push_error("Invalid mutation energy phase: %s" % energy_phase)
			return 0


func _fill_available_mutations() -> void:
	available_mutations = IVMutations.mutations.duplicate()


func _handle_collected_cell_created(collected_cell: BrainCell) -> void:
	for mutation: BrainCellMutation in collected_cell.mutations:
		if not mutation.hidden:
			GLMutationSeenManagerBus.emit_signal(
				"mutation_seen_by_player",
				mutation.type
			)

		_remove_available_mutation_type(mutation.type)


func _remove_available_mutation_type(mutation_type: String) -> void:
	for index: int in range(available_mutations.size() - 1, -1, -1):
		if available_mutations[index].type == mutation_type:
			available_mutations.remove_at(index)
