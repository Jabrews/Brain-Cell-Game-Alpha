extends Node

@export var cell_container_parent_node: Node


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		trigger_respected_mutation_event(0)

	elif Input.is_action_just_pressed("debug2"):
		trigger_respected_mutation_event(1)

	elif Input.is_action_just_pressed("debug3"):
		trigger_respected_mutation_event(2)


func trigger_respected_mutation_event(number: int) -> void:
	if cell_container_parent_node.get_child_count() == 0:
		push_warning("No cell container found.")
		return

	var cell_container := cell_container_parent_node.get_child(0) as CharacterBody3D

	if cell_container == null:
		push_warning("First child is not a CharacterBody3D.")
		return

	var cell: BrainCell = cell_container.designated_brain_cell

	if cell == null:
		push_warning("Cell container has no designated brain cell.")
		return

	if number < 0 or number >= cell.mutations.size():
		push_warning("Mutation index %s does not exist." % number)
		return

	var mutation: BrainCellMutation = cell.mutations[number]

	# Find the random event belonging to this mutation.
	for mutation_event: MutationEvent in mutation.mutation_events:
		if mutation_event.event_type != "random_event":
			continue

		GLMutationEventBus.emit_signal(
			"attempt_to_trigger_random_mutation_event",
			mutation_event,
			cell
		)

		return
