extends Node


func _handle_sort(
	prisoner_cells: Array[BrainCell]
) -> Array[BrainCell]:

	if prisoner_cells.is_empty():
		push_error('handle sort cells given empty array')
		return prisoner_cells

	var amount_of_best_cells_to_sort: int = clamp(
		IVMutations.amount_of_best_cells_sorted,
		0,
		prisoner_cells.size()
	)

	# Duplicate so the original array is not reordered.
	var sorted_cells: Array[BrainCell] = prisoner_cells.duplicate()

	# Sort all cells from highest score to lowest score.
	sorted_cells.sort_custom(_sort_by_score)

	var best_cells: Array[BrainCell] = []
	var remaining_cells: Array[BrainCell] = []

	for index: int in range(sorted_cells.size()):
		var cell: BrainCell = sorted_cells[index]

		if index < amount_of_best_cells_to_sort:
			best_cells.append(cell)
		else:
			remaining_cells.append(cell)

	# Only the cells outside the selected top amount become random.
	remaining_cells.shuffle()

	best_cells.append_array(remaining_cells)

	return best_cells


func _sort_by_score(cell_a: BrainCell, cell_b: BrainCell) -> bool:
	return _get_cell_score(cell_a) > _get_cell_score(cell_b)


func _get_cell_score(cell: BrainCell) -> float:
	
	var total_clean: float = (
		cell.strength.value
		+ cell.intelligence.value
		+ cell.community.value
	)

	var total_defect: float = (
		cell.strength.defect
		+ cell.intelligence.defect
		+ cell.community.defect
	) * 1
	
	var stats_hidden: int = 0

	if cell.strength.hidden:
		stats_hidden += 1

	if cell.intelligence.hidden:
		stats_hidden += 1

	if cell.community.hidden:
		stats_hidden += 1
		
	# chance for stats hidden score to be reduced.
	# is best as we go further in round and there are more hidden stats	
	var ran_num : int = randi_range(0, 100)
	if ran_num <= IVMutations.chance_to_weight_hidden_stats_low :
		
		if GameAdminPanel.enabled :
			GameAdminPanel.updater_admin_batch_mutation.weighed_hidden_stats_lower = true
		
		return total_clean - total_defect - (stats_hidden * 4) 
		
	else : 
		return total_clean - total_defect - (stats_hidden * 10) 
