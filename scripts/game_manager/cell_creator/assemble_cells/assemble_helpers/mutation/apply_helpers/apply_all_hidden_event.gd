extends Node

@export var mutation_seen_manager: Node


func _handle_apply(
	prisoner_cells: Array[BrainCell],
	mutations_available: Array[BrainCellMutation]
) -> Array[BrainCell]:

	if prisoner_cells.is_empty():
		return prisoner_cells

	var possible_cells: Array[BrainCell] = prisoner_cells.duplicate()

	# Apply real mutations starting from the first cell.
	while not mutations_available.is_empty() and not possible_cells.is_empty():
		var cell: BrainCell = possible_cells.pop_front()

		apply_mutation_to_cell(cell, mutations_available)

	# Every remaining cell gets one hidden "none" mutation.
	for cell: BrainCell in possible_cells:
		apply_hidden_none_mutation_to_cell(cell)

	return prisoner_cells


func apply_mutation_to_cell(
	cell: BrainCell,
	mutations_available: Array[BrainCellMutation]
) -> void:

	if cell == null or mutations_available.is_empty():
		return

	var mutation: BrainCellMutation = mutations_available.pop_front()

	mutation.hidden = true
	cell.mutations = [mutation]


func apply_hidden_none_mutation_to_cell(cell: BrainCell) -> void:
	if cell == null:
		return

	var hidden_none_mutation := BrainCellMutation.new("none", true)
	hidden_none_mutation.hidden = true

	cell.mutations = [hidden_none_mutation]
