extends Node

# components
@export var cell_container_parent_node : Node


func _handle_jolt() :

	# get container character bodies
	var container_cells = cell_container_parent_node.get_children()

	# remove frozen cells
	var valid_cells = []

	for cell in container_cells:

		if not cell.designated_brain_cell.cell_is_frozen:
			valid_cells.append(cell)

	# leave if no valid cells
	if valid_cells.is_empty():
		return

	# pick random valid container
	var random_container_cell = valid_cells.pick_random()

	# emit signal
	GLDefectEventMangerBus.emit_signal(
		"event_cell_container_jolt",
		random_container_cell.designated_brain_cell.name
	)
