extends Node


# Main variables
var prisoner_cells: Array[BrainCell] = []
var collected_cells: Array[BrainCell] = []


func _ready() -> void:
	# Cell creation and changes
	GLCellManagerBus.connect("create_prisoner_cells", _handle_create_prisoner_cells)
	GLCellManagerBus.connect("prisoner_picked_by_player", _handle_prisoner_picked_by_player)
	GLCellManagerBus.connect("collected_cell_created", _handle_collected_cell_created)
	GLCellManagerBus.connect("collected_cell_changed", _handle_collected_cell_changed)

	# Cell deletion
	GLCellManagerBus.connect("delete_remaining_prisoners", _handle_delete_remaining_prisoners)
	GLCellManagerBus.connect("delete_selected_collected_cell", _handle_delete_selected_collected_cell)
	GLCellManagerBus.connect("delete_cells_for_next_goal_piece", _handle_delete_cells_for_next_goal_piece)

	# Turn progression
	GLGameManagerBus.connect("proceed_next_turn", _handle_proceed_next_turn)

	# Debug
	GLCellManagerBus.connect("debug_create_collected_cells", _handle_debug_create_collected_cells)
	GLCellManagerBus.connect("debug_unhide_collected_cell_mutation", _handle_debug_unhide_collected_cell_mutation)


#### Setters ####

func set_collected_cells(new_cells: Array[BrainCell]) -> void:
	collected_cells = new_cells
	GLCellManagerBus.collected_cells_refrence = new_cells
	GLCellManagerBus.emit_signal("cells_updated")


func set_prisoner_cells(new_cells: Array[BrainCell]) -> void:
	prisoner_cells = new_cells
	GLCellManagerBus.prisoner_cells_refrence = new_cells
	GLCellManagerBus.emit_signal("cells_updated")


#### Updaters ####

func update_collected_cells(cells_to_update: Array[BrainCell]) -> void:
	if cells_to_update.is_empty():
		push_error("Cell manager: collected-cell update array is empty.")
		return

	var new_collected_cells: Array[BrainCell] = []

	for cell in collected_cells:
		var updated_cell: BrainCell = cell

		for update_cell in cells_to_update:
			if cell.name == update_cell.name:
				updated_cell = update_cell
				GLCellManagerBus.emit_signal("cell_changed", update_cell)
				break

		if check_collected_cell_dead(updated_cell):
			GLCellManagerBus.emit_signal("cell_deleted", updated_cell.name)
		else:
			new_collected_cells.append(updated_cell)

	set_collected_cells(new_collected_cells)


func update_prisoner_cells(cells_to_update: Array[BrainCell]) -> void:
	if cells_to_update.is_empty():
		push_error("Cell manager: prisoner-cell update array is empty.")
		return

	var new_prisoner_cells: Array[BrainCell] = []

	for cell in prisoner_cells:
		var updated_cell: BrainCell = cell

		for update_cell in cells_to_update:
			if cell.name == update_cell.name:
				updated_cell = update_cell
				GLCellManagerBus.emit_signal("cell_changed", update_cell)
				break

		new_prisoner_cells.append(updated_cell)

	set_prisoner_cells(new_prisoner_cells)


#### Delete cells ####

func delete_collected_cells(cells_to_delete: Array[BrainCell]) -> void:
	if cells_to_delete.is_empty():
		push_error("Cell manager: collected-cell delete array is empty.")
		return

	var new_collected_cells: Array[BrainCell] = []

	for cell in collected_cells:
		var should_delete := false

		for delete_cell in cells_to_delete:
			if cell.name == delete_cell.name:
				should_delete = true
				GLCellManagerBus.emit_signal("cell_deleted", cell.name)
				break

		if not should_delete:
			new_collected_cells.append(cell)

	set_collected_cells(new_collected_cells)


func delete_prisoner_cells(cells_to_delete: Array[BrainCell]) -> void:
	if cells_to_delete.is_empty():
		push_error("Cell manager: prisoner-cell delete array is empty.")
		return

	var new_prisoner_cells: Array[BrainCell] = []

	for cell in prisoner_cells:
		var should_delete := false

		for delete_cell in cells_to_delete:
			if cell.name == delete_cell.name:
				should_delete = true
				GLCellManagerBus.emit_signal("cell_deleted", cell.name)
				break

		if not should_delete:
			new_prisoner_cells.append(cell)

	set_prisoner_cells(new_prisoner_cells)


#### Check if cell is dead ####

func check_collected_cell_dead(collected_cell: BrainCell) -> bool:
	var max_stat_value: float = IVCellCreator.max_stat_value

	if collected_cell.strength.defect >= max_stat_value:
		return true

	if collected_cell.intelligence.defect >= max_stat_value:
		return true

	if collected_cell.community.defect >= max_stat_value:
		return true

	return collected_cell.life_span <= 0


#### Core handlers ####

func _handle_create_prisoner_cells(new_prisoner_cells: Array[BrainCell]) -> void:
	set_prisoner_cells(new_prisoner_cells)


func _handle_prisoner_picked_by_player(prisoner_cell: BrainCell) -> void:
	delete_prisoner_cells([prisoner_cell])
	GLCellManagerBus.emit_signal("cell_added_to_collection", prisoner_cell)


func _handle_collected_cell_created(collected_cell: BrainCell) -> void:
	for index in range(collected_cell.mutations.size() - 1, -1, -1):
		if collected_cell.mutations[index].type == "none":
			collected_cell.mutations.remove_at(index)

	var new_collected_cells: Array[BrainCell] = collected_cells.duplicate()
	new_collected_cells.append(collected_cell)
	set_collected_cells(new_collected_cells)


func _handle_delete_remaining_prisoners() -> void:
	for cell in prisoner_cells:
		GLCellManagerBus.emit_signal("cell_deleted", cell.name)

	set_prisoner_cells([])


func _handle_delete_selected_collected_cell(collected_cell: BrainCell) -> void:
	delete_collected_cells([collected_cell])


func _handle_delete_cells_for_next_goal_piece() -> void:
	for cell in collected_cells:
		cell.turn_into_flesh_bug = false
		GLCellManagerBus.emit_signal("cell_changed", cell)
		GLCellManagerBus.emit_signal("cell_deleted", cell.name)

	for cell in prisoner_cells:
		GLCellManagerBus.emit_signal("cell_deleted", cell.name)

	set_collected_cells([])
	set_prisoner_cells([])


func _handle_collected_cell_changed(cell: BrainCell) -> void:
	var all_stats_disabled: bool = (
		not cell.strength.enabled
		and not cell.intelligence.enabled
		and not cell.community.enabled
	)

	if all_stats_disabled:
		delete_collected_cells([cell])
	else:
		update_collected_cells([cell])


func _handle_proceed_next_turn() -> void:
	# Clear the breeder-unavailable flag.
	for cell in collected_cells:
		cell.breeder_unavaible = false
		update_collected_cells([cell])

	# Decrease lifespan unless the cell is frozen.
	for cell in collected_cells:
		if cell.cell_is_frozen:
			cell.cell_is_frozen = false
		else:
			cell.life_span -= 1

		update_collected_cells([cell])


#### Debug ####

func _handle_debug_create_collected_cells(new_collected_cells: Array[BrainCell]) -> void:
	set_collected_cells(new_collected_cells)


func _handle_debug_unhide_collected_cell_mutation(selected_cell: BrainCell) -> void:
	for index in range(selected_cell.mutations.size() - 1, -1, -1):
		var mutation: BrainCellMutation = selected_cell.mutations[index]
		mutation.hidden = false

		if mutation.type == "none":
			selected_cell.mutations.remove_at(index)

	update_collected_cells([selected_cell])
