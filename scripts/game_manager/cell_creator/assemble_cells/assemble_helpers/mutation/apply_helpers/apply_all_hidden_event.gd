extends Node

@export var mutation_seen_manager: Node


func _handle_apply(
	prisoner_cells: Array[BrainCell],
	mutations_available: Array[BrainCellMutation],
	force_mutation_urgency: bool,
) -> Array[BrainCell]:

	if prisoner_cells.is_empty():
		return prisoner_cells

	var possible_cells: Array[BrainCell] = prisoner_cells.duplicate()

	if force_mutation_urgency:
		_apply_urgent_mutations(possible_cells, mutations_available)
	else:
		_apply_regular_mutations(possible_cells, mutations_available)

	GLPrisonerSpawnerBus.emit_signal('apply_mutations_all_hidden')

	return prisoner_cells


func _apply_regular_mutations(
	possible_cells: Array[BrainCell],
	mutations_available: Array[BrainCellMutation]
) -> void:

	# Apply available mutations starting from the first cell.
	while not mutations_available.is_empty() and not possible_cells.is_empty():
		var cell: BrainCell = possible_cells.pop_front()
		var mutation: BrainCellMutation = mutations_available.pop_front()

		_set_hidden_mutation(cell, mutation)

	# Every remaining cell receives a hidden "none" mutation.
	for cell: BrainCell in possible_cells:
		_apply_hidden_none_mutation_to_cell(cell)


func _apply_urgent_mutations(
	possible_cells: Array[BrainCell],
	mutations_available: Array[BrainCellMutation]
) -> void:

	var used_mutation_types: Array[String] = []

	# Use available mutations first.
	while not mutations_available.is_empty() and not possible_cells.is_empty():
		var mutation: BrainCellMutation = _take_unique_mutation(
			mutations_available,
			used_mutation_types,
			false
		)

		if mutation == null:
			break

		var cell: BrainCell = possible_cells.pop_front()

		_set_hidden_mutation(cell, mutation)
		used_mutation_types.append(mutation.type)

	# Build a pool of unused bad mutations.
	var unused_bad_mutations: Array[BrainCellMutation] = []

	for mutation: BrainCellMutation in IVMutations.bad_mutations:
		if mutation == null:
			continue

		if mutation.type == "none":
			continue

		if mutation.type in used_mutation_types:
			continue

		if _pool_contains_type(unused_bad_mutations, mutation.type):
			continue

		unused_bad_mutations.append(mutation)

	# Give remaining cells random, non-repeating bad mutations.
	while not possible_cells.is_empty() and not unused_bad_mutations.is_empty():
		var cell: BrainCell = possible_cells.pop_front()

		var mutation_index: int = randi_range(
			0,
			unused_bad_mutations.size() - 1
		)

		var mutation: BrainCellMutation = unused_bad_mutations.pop_at(
			mutation_index
		)

		_set_hidden_mutation(cell, mutation)
		used_mutation_types.append(mutation.type)

	# This only happens when there are not enough unique mutations.
	if not possible_cells.is_empty():
		push_warning(
			"Not enough unique bad mutations to mutate every cell."
		)

		for cell: BrainCell in possible_cells:
			_apply_hidden_none_mutation_to_cell(cell)


func _take_unique_mutation(
	mutation_pool: Array[BrainCellMutation],
	used_mutation_types: Array[String],
	random_selection: bool
) -> BrainCellMutation:

	for index: int in range(mutation_pool.size()):
		var mutation: BrainCellMutation = mutation_pool[index]

		if mutation == null:
			continue

		if mutation.type in used_mutation_types:
			continue

		if random_selection:
			break

		mutation_pool.remove_at(index)
		return mutation

	return null


func _set_hidden_mutation(
	cell: BrainCell,
	source_mutation: BrainCellMutation
) -> void:

	if cell == null or source_mutation == null:
		return

	# Create a new mutation so the global mutation object is not modified.
	var mutation_copy := BrainCellMutation.new(
		source_mutation.type,
		true
	)

	mutation_copy.hidden = true
	cell.mutations = [mutation_copy]


func _apply_hidden_none_mutation_to_cell(cell: BrainCell) -> void:
	if cell == null:
		return

	var hidden_none_mutation := BrainCellMutation.new("none", true)
	hidden_none_mutation.hidden = true

	cell.mutations = [hidden_none_mutation]


func _pool_contains_type(
	mutation_pool: Array[BrainCellMutation],
	mutation_type: String
) -> bool:

	for mutation: BrainCellMutation in mutation_pool:
		if mutation.type == mutation_type:
			return true

	return false
