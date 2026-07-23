extends Node


@export var cell_manager: Node
@export var entity_room_management: Node


var chance_to_trigger_other_room_cell: int = 25


func _send_event() -> bool:
	var player_room_name: String = get_player_room_name()

	var target_other_room: bool = (
		randi_range(1, 100)
		<= chance_to_trigger_other_room_cell
	)

	# Interpreter cells are either allowed into the pool or excluded.
	# They are never specifically prioritized.
	var include_interpreter_cells: bool = (
		randi_range(1, 100)
		<= IVRandomMutationEventTrigger.chance_for_mutation_on_interpeter_cell
	)

	var possible_targets: Array[Dictionary] = get_possible_targets(
		player_room_name,
		target_other_room,
		include_interpreter_cells,
		true
	)

	# If the chosen room group has no targets, search every room.
	if possible_targets.is_empty():
		possible_targets = get_possible_targets(
			player_room_name,
			target_other_room,
			include_interpreter_cells,
			false
		)

	if possible_targets.is_empty():
		print("Unable to find an eligible cell with a random mutation event")
		return false

	var random_target: Dictionary = possible_targets.pick_random()

	GLMutationEventBus.emit_signal(
		"attempt_to_trigger_random_mutation_event",
		random_target["mutation_event"],
		random_target["cell"]
	)

	return true


func get_possible_targets(
	player_room_name: String,
	target_other_room: bool,
	include_interpreter_cells: bool,
	filter_by_room: bool
) -> Array[Dictionary]:
	var possible_targets: Array[Dictionary] = []

	for collected_cell: BrainCell in cell_manager.collected_cells:
		var cell_container: Node = get_cell_container_node(
			collected_cell.name
		)

		if cell_container == null:
			continue

		# Do not put interpreter cells into the pool when the roll fails.
		if (
			cell_container.on_stat_interpreter
			and not include_interpreter_cells
		):
			continue

		var cell_room_name: String = get_cell_room_name(
			collected_cell.name
		)

		if filter_by_room:
			if target_other_room:
				if cell_room_name == player_room_name:
					continue
			else:
				if cell_room_name != player_room_name:
					continue

		for mutation: BrainCellMutation in collected_cell.mutations:
			for mutation_event: MutationEvent in mutation.mutation_events:
				if mutation_event.event_type != "random_event":
					continue

				possible_targets.append({
					"cell": collected_cell,
					"mutation_event": mutation_event,
				})

	return possible_targets


func get_player_room_name() -> String:
	for room_profile: EntityRoomProfile in entity_room_management.entity_room_profiles:
		if room_profile.entity_type == "player":
			return room_profile.room_name

	return ""


func get_cell_room_name(cell_name: String) -> String:
	for room_profile: EntityRoomProfile in entity_room_management.entity_room_profiles:
		if room_profile.entity_type != "cell_container":
			continue

		if room_profile.entity_name == cell_name:
			return room_profile.room_name

	return ""


func get_cell_container_node(cell_name: String) -> Node:
	for cell_container: Node in cell_manager.get_children():
		if cell_container.name == cell_name:
			return cell_container

	return null
