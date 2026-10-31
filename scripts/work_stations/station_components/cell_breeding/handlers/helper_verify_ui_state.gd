extends Node


func _verify() -> void:
	var ui_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_ui_state.duplicate()
	var collected_cells: Array[BrainCell] = GLCellManagerBus.collected_cells_refrence

	for slot: String in ui_state.keys():
		var ui_cell: BrainCell = ui_state[slot]

		if ui_cell == null:
			continue

		var found: bool = false

		for collected_cell: BrainCell in collected_cells:
			if collected_cell != null and collected_cell.name == ui_cell.name:
				found = true
				break

		if not found:
			ui_state[slot] = null

	# Save the changes; ui_state is a duplicate.
	GLBreedingComponetsBus.breeding_ui_state = ui_state
