extends Node


var available_mutations: Array[BrainCellMutation] = []


func _ready() -> void:
	GLGameManagerBus.connect(
		"process_next_round",
		_handle_process_next_round
	)

	GLCellManagerBus.connect(
		"prisoner_picked_by_player",
		_handle_prisoner_picked_by_player
	)

	_fill_available_mutations()


func _get_mutations(
	energy_phase: int
) -> Array[BrainCellMutation]:
	var selected_mutations: Array[BrainCellMutation] = []

	_update_admin_available_mutations()

	if available_mutations.is_empty():
		_set_admin_skip_reason("available mutations empty")
		return selected_mutations

	var min_amount: int = IVMutations.min_mutations_per_batch
	var max_amount: int = IVMutations.max_mutations_per_batch

	if max_amount <= 0:
		_set_admin_skip_reason("maximum mutations is 0")
		return selected_mutations

	if min_amount < 0:
		push_error("Minimum mutations cannot be below 0.")
		min_amount = 0

	if min_amount > max_amount:
		push_error("Minimum mutations cannot be above maximum.")
		min_amount = max_amount

	_update_admin_mutation_limits(
		min_amount,
		max_amount,
		energy_phase
	)

	var mutation_amount: int = min_amount
	var extra_mutation_chance: int = (
		get_energy_phase_chance(energy_phase)
	)

	var extra_slots: int = max_amount - min_amount

	for slot: int in range(extra_slots):
		var roll: int = randi_range(1, 100)

		if roll <= extra_mutation_chance:
			mutation_amount += 1

	# Always select at least one mutation when:
	# - mutations are available
	# - max_amount allows mutations
	if mutation_amount == 0:
		mutation_amount = 1

	mutation_amount = mini(
		mutation_amount,
		available_mutations.size()
	)

	var mutation_pool: Array[BrainCellMutation] = (
		available_mutations.duplicate()
	)

	for amount: int in range(mutation_amount):
		if mutation_pool.is_empty():
			break

		var selected_mutation: BrainCellMutation = (
			mutation_pool.pick_random()
		)

		selected_mutations.append(selected_mutation)

		# Prevent duplicate mutation types in this batch.
		for index: int in range(
			mutation_pool.size() - 1,
			-1,
			-1
		):
			if mutation_pool[index].type == selected_mutation.type:
				mutation_pool.remove_at(index)

	_update_admin_chosen_mutations(selected_mutations)

	return selected_mutations


func _update_admin_available_mutations() -> void:
	if not GameAdminPanel.enabled:
		return

	var admin_batch: AdminBatchMutation = (
		GameAdminPanel.updater_admin_batch_mutation
	)

	admin_batch.mutations_available.clear()

	for mutation: BrainCellMutation in available_mutations:
		admin_batch.mutations_available.append(mutation.type)


func _update_admin_mutation_limits(
	min_amount: int,
	max_amount: int,
	energy_phase: int
) -> void:
	if not GameAdminPanel.enabled:
		return

	var admin_batch: AdminBatchMutation = (
		GameAdminPanel.updater_admin_batch_mutation
	)

	admin_batch.min_mutations = min_amount
	admin_batch.max_mutations = max_amount
	admin_batch.energy_phase = energy_phase


func _update_admin_chosen_mutations(
	selected_mutations: Array[BrainCellMutation]
) -> void:
	if not GameAdminPanel.enabled:
		return

	var admin_batch: AdminBatchMutation = (
		GameAdminPanel.updater_admin_batch_mutation
	)

	admin_batch.mutations_chosen.clear()

	for mutation: BrainCellMutation in selected_mutations:
		admin_batch.mutations_chosen.append(mutation.type)


func _set_admin_skip_reason(reason: String) -> void:
	if not GameAdminPanel.enabled:
		return

	var admin_batch: AdminBatchMutation = (
		GameAdminPanel.updater_admin_batch_mutation
	)

	admin_batch.skipped = true
	admin_batch.why_skipped = reason


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


func _handle_process_next_round() -> void:
	_fill_available_mutations()


func _fill_available_mutations() -> void:
	available_mutations = IVMutations.mutations.duplicate()


func _handle_prisoner_picked_by_player(
	prisoner_cell: BrainCell
) -> void:
	for mutation: BrainCellMutation in prisoner_cell.mutations:
		if not mutation.hidden:
			GLMutationSeenManagerBus.emit_signal(
				"mutation_seen_by_player",
				mutation.type
			)

		_remove_available_mutation_type(mutation.type)


func _remove_available_mutation_type(
	mutation_type: String
) -> void:
	for index: int in range(
		available_mutations.size() - 1,
		-1,
		-1
	):
		if available_mutations[index].type == mutation_type:
			available_mutations.remove_at(index)
