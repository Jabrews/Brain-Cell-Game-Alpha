extends Node

@export var mutation_seen_manager: Node


func _handle_apply(
	prisoner_cells: Array[BrainCell],
	mutations_available: Array[BrainCellMutation]
) -> Array[BrainCell]:
	if prisoner_cells.is_empty():
		return prisoner_cells

	var possible_cells: Array[BrainCell] = prisoner_cells.duplicate()

	# Prevent this function from removing mutations from the original array.
	var remaining_mutations: Array[BrainCellMutation] = (
		mutations_available.duplicate()
	)

	GLPrisonerSpawnerBus.emit_signal(
		"apply_mutation_regular",
		remaining_mutations.size()
	)

	var has_hidden_real_mutation: bool = false

	# Apply real mutations starting from the first cell.
	while (not remaining_mutations.is_empty() and not possible_cells.is_empty() ):
		var cell: BrainCell = possible_cells.pop_front()

		var mutation_was_hidden: bool = apply_real_mutation(
			cell,
			remaining_mutations
		)

		if mutation_was_hidden:
			has_hidden_real_mutation = true

	# Fake mutations are only necessary when at least one real
	# mutation is hidden.
	if has_hidden_real_mutation:
		apply_fake_mutations(possible_cells)

	return prisoner_cells


func apply_real_mutation(
	cell: BrainCell,
	mutations_available: Array[BrainCellMutation]
) -> bool:
	if cell == null or mutations_available.is_empty():
		return false

	var mutation: BrainCellMutation = mutations_available.pop_front()

	var mutation_seen: bool = mutation_seen_manager._find_mutation_seen(
		mutation.type
	)

	mutation.hidden = (
		not mutation_seen
		or randi_range(1, 100) <= IVMutations.chance_to_hide_mutation
	)

	# Sentient should always be visible.
	if mutation.type == "sentient":
		mutation.hidden = false
		
	set_cell_mutation(cell, mutation)

	return mutation.hidden


func apply_fake_mutations(
	possible_cells: Array[BrainCell]
) -> void:
	if possible_cells.is_empty():
		return

	var max_amount: int = min(
		IVMutations.max_fake_mutations_per_batch,
		possible_cells.size()
	)

	var min_amount: int = clamp(
		IVMutations.min_fake_mutations_per_batch,
		0,
		max_amount
	)

	var fake_mutation_amount: int = randi_range(
		min_amount,
		max_amount
	)

	for i: int in range(fake_mutation_amount):
		if possible_cells.is_empty():
			return

		var cell: BrainCell = possible_cells.pop_front()

		var fake_mutation: BrainCellMutation = BrainCellMutation.new(
			"none",
			true,
			[]
		)

		set_cell_mutation(cell, fake_mutation)


func set_cell_mutation(
	cell: BrainCell,
	mutation: BrainCellMutation
) -> void:
	if cell == null or mutation == null:
		return

	cell.mutations = [mutation]
