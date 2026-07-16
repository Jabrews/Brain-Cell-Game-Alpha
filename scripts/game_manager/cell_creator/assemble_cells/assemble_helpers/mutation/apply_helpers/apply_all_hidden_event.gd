extends Node

# components
@onready var get_best_cell: Node = $"../GetBestCell"

@export var mutation_seen_manager: Node


func _handle_apply( prisoner_cells: Array[BrainCell], mutations_available: Array[BrainCellMutation]) -> Array[BrainCell]:
	
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
		var random_cell: BrainCell = possible_cells.pick_random()
		possible_cells.erase(random_cell)

		mutations_available = apply_mutation_to_cell(random_cell, mutations_available)

	### ANY LEFTOVER CELLS GET HIDDEN NONE MUTATION ###
	for cell: BrainCell in possible_cells:
		apply_hidden_none_mutation_to_cell(cell)

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

	# All real mutations are hidden.
	cell.mutation.hidden = true

	return mutations_available


func apply_hidden_none_mutation_to_cell(cell: BrainCell) -> void:
	if cell == null:
		return

	var hidden_none_mutation: BrainCellMutation = BrainCellMutation.new("none", true)
	hidden_none_mutation.hidden = true

	cell.mutation = hidden_none_mutation
