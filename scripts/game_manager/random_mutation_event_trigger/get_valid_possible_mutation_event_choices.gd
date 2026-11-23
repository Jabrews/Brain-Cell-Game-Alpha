extends Node


func _get_possible() -> Array[PossibleMutationEventChoice]:
	var possible_mutation_event_choices: Array[PossibleMutationEventChoice] = []
	var collected_cells: Array[BrainCell] = GLCellManagerBus.collected_cells_refrence

	for cell: BrainCell in collected_cells:
		if cell == null:
			continue

		var cell_room_valid: bool = verify_cell_room_valid(cell.name)

		# In round 1, out-of-room cells only have a chance to be included.
		if not cell_room_valid and GLGameManagerBus.current_round == 1:
			if not cell.mutations.is_empty():
				var chance_to_include: int = clampi(
					IVRandomMutationEventTrigger
						.chance_to_include_out_of_room_cell_first_round,
					0,
					100
				)

				if randi_range(1, 100) > chance_to_include:
					continue

		if cell.mutations.is_empty():
			continue

		for mutation: BrainCellMutation in cell.mutations:
			if mutation == null:
				continue

			for mutation_event: MutationEvent in mutation.mutation_events:
				if mutation_event == null:
					continue

				if mutation_event.event_type != "random_event":
					continue

				possible_mutation_event_choices.append(
					PossibleMutationEventChoice.new(
						mutation_event,
						cell,
						cell_room_valid
					)
				)

	return possible_mutation_event_choices


func verify_cell_room_valid(cell_name: String) -> bool:
	var room_profiles: Array[EntityRoomProfile] = (
		GLEntityRoomManagementBus.entity_room_profiles
	)

	var cell_room_profile: EntityRoomProfile = null
	var player_room_profile: EntityRoomProfile = null

	for room_profile: EntityRoomProfile in room_profiles:
		if room_profile == null:
			continue

		if (
			room_profile.entity_type == "cell_container"
			and room_profile.entity_name == cell_name
		):
			cell_room_profile = room_profile

		if (
			room_profile.entity_type == "player"
			and room_profile.entity_name == "player"
		):
			player_room_profile = room_profile

	if cell_room_profile == null or player_room_profile == null:
		push_error(
			"Unable to find cell or player room profile: %s %s %s"
			% [cell_room_profile, player_room_profile, cell_name]
		)
		return false

	return cell_room_profile.room_name == player_room_profile.room_name
