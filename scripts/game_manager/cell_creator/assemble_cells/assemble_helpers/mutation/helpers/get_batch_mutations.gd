
extends Node


var available_mutations: Array[BrainCellMutation] = []


func _ready() -> void:
	GLGameManagerBus.connect(
		"process_next_round",
		_handle_process_next_round
	)

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
	var extra_mutation_chance: int = (
		get_energy_phase_chance(energy_phase)
	)

	# Every slot above the minimum gets its own roll.
	var extra_slots: int = max_amount - min_amount

	for slot: int in range(extra_slots):
		var roll: int = randi_range(1, 100)

		# min chance passed. add an extra mutation
		if roll <= extra_mutation_chance:
			mutation_amount += 1

	# Cannot select more mutations than remain available.
	if mutation_amount > available_mutations.size():
		mutation_amount = available_mutations.size()

	for amount: int in range(mutation_amount):
		var selected_mutation: BrainCellMutation = (
			available_mutations.pick_random()
		)

		# add to selected
		selected_mutations.append(selected_mutation)
		# delete from avaible
		available_mutations.erase(selected_mutation)

	return selected_mutations


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
