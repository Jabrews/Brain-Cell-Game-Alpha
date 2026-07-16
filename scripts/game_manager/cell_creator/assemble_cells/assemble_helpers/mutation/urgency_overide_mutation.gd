extends Node


func _check_overide() -> bool:
	if GLGameManagerBus.current_round == 1:
		return false

	# Do not override until the player has used at least 60% of their energy.
	var current_energy: int = GLGameManagerBus.curr_energy
	var max_energy: int = GLGameManagerBus.max_energy
	var energy_used: int = max_energy - current_energy
	var required_energy_used: float = max_energy * 0.60

	if energy_used < required_energy_used:
		return false

	var collected_cells: Array[BrainCell] = (
		GLCellManagerBus.collected_cells_refrence
	)

	if collected_cells.is_empty():
		return false

	# Override if at least one cell has no real mutation.
	for cell: BrainCell in collected_cells:
		if not _cell_has_real_mutation(cell):
			return true

	return false


func _cell_has_real_mutation(cell: BrainCell) -> bool:
	for mutation: BrainCellMutation in cell.mutations:
		if mutation.type != "none":
			return true

	return false
