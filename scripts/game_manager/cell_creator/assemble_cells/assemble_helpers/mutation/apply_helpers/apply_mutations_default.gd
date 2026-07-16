extends Node

# components
@onready var get_best_cell: Node = $"../GetBestCell"

@export var mutation_seen_manager: Node


func _handle_apply( prisoner_cells: Array[BrainCell], mutations_available: Array[BrainCellMutation] ) -> Array[BrainCell]:

	if prisoner_cells.is_empty():
		return prisoner_cells

	var possible_cells: Array[BrainCell] = prisoner_cells.duplicate()

	### CHANCE TO APPLY TO BEST CELL FIRST ###
	if not mutations_available.is_empty():
		var chance_to_target_best_cell: int = IVMutations.chance_to_target_best_cell_for_mutation
		var target_ran_num: int = randi_range(1, 100)

		if target_ran_num <= chance_to_target_best_cell:
			var best_cell: BrainCell = get_best_cell._get_cell(possible_cells)

			if best_cell:
				possible_cells.erase(best_cell)
				mutations_available = apply_mutation_to_cell(best_cell, mutations_available)

	### APPLY REST OF REAL MUTATIONS RANDOMLY ###
	while not mutations_available.is_empty() and not possible_cells.is_empty():
		var cell: BrainCell = possible_cells.pick_random()
		possible_cells.erase(cell)

		mutations_available = apply_mutation_to_cell(cell, mutations_available)

	### APPLY FAKE HIDDEN MUTATIONS TO REMAINING CELLS ###
	_apply_fake_mutations(possible_cells)

	return prisoner_cells


func apply_mutation_to_cell(
	cell: BrainCell,
	mutations_available: Array[BrainCellMutation]
) -> Array[BrainCellMutation]:

	if cell == null:
		return mutations_available

	if mutations_available.is_empty():
		return mutations_available

	var random_mutation: BrainCellMutation = mutations_available.pick_random()
	mutations_available.erase(random_mutation)

	cell.mutation = random_mutation

	# Reset hidden first so old state does not leak.
	cell.mutation.hidden = false

	var mutation_seen: bool = mutation_seen_manager._find_mutation_seen(random_mutation.type)

	# If the mutation has never been seen, always hide it.
	if not mutation_seen:
		cell.mutation.hidden = true
		return mutations_available

	# If the mutation has been seen, maybe hide it anyway.
	var hide_num: int = randi_range(1, 100)

	if hide_num <= IVMutations.chance_to_hide_mutation:
		cell.mutation.hidden = true

	return mutations_available


func _apply_fake_mutations(possible_cells: Array[BrainCell]) -> void:
	if possible_cells.is_empty():
		return

	var min_fake_mutations_per_batch: int = IVMutations.min_fake_mutations_per_batch
	var max_fake_mutations_per_batch: int = IVMutations.max_fake_mutations_per_batch

	max_fake_mutations_per_batch = min(
		max_fake_mutations_per_batch,
		possible_cells.size()
	)

	min_fake_mutations_per_batch = clamp(
		min_fake_mutations_per_batch,
		0,
		max_fake_mutations_per_batch
	)

	var fake_mutation_amount: int = randi_range(
		min_fake_mutations_per_batch,
		max_fake_mutations_per_batch
	)

	for i in range(fake_mutation_amount):
		if possible_cells.is_empty():
			return

		var cell: BrainCell = possible_cells.pick_random()
		possible_cells.erase(cell)

		cell.mutation = _create_fake_mutation()


func _create_fake_mutation() -> BrainCellMutation:
	var fake_mutation := BrainCellMutation.new("none", true)

	# Fake mutations should always be hidden.
	fake_mutation.hidden = true

	return fake_mutation
