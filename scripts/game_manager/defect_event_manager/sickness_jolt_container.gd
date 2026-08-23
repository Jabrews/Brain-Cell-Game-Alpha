extends Node


func _handle_sickness() -> void:

	# Find the room with the most cells in it.
	var room_scores: Dictionary[String, int] = {
		'main_room': 0,
		'interpreter_room': 0,
		'prisoner_room': 0,
		'comparison_room': 0,
	}


	# Add score through entity profiles.
	for entity_profile: EntityRoomProfile in GLEntityRoomManagementBus.entity_room_profiles:

		if entity_profile.entity_type != 'cell_container':
			continue

		if room_scores.has(entity_profile.room_name):
			room_scores[entity_profile.room_name] += 1


	# Find the highest score.
	var highest_score: int = 0

	for room_name: String in room_scores:

		if room_scores[room_name] > highest_score:
			highest_score = room_scores[room_name]


	# If every room is empty, do nothing.
	if highest_score == 0:
		return


	# Find all rooms tied for the highest score.
	var winning_rooms: Array[String] = []

	for room_name: String in room_scores:

		if room_scores[room_name] == highest_score:
			winning_rooms.append(room_name)


	# Randomly choose one of the winning rooms.
	var chosen_room: String = winning_rooms.pick_random()


	# Find all cells currently inside the chosen room.
	var cells_in_room: Array[String] = []

	for entity_profile: EntityRoomProfile in GLEntityRoomManagementBus.entity_room_profiles:

		if entity_profile.entity_type != 'cell_container':
			continue

		if entity_profile.room_name != chosen_room:
			continue

		cells_in_room.append(entity_profile.entity_name)


	# Safety check.
	if cells_in_room.is_empty():
		return


	# Randomly choose a cell from that room.
	var cell_name: String = cells_in_room.pick_random()


	# Trigger sickness event.
	GLDefectEventMangerBus.emit_signal('initate_defect_event_cell_container', 'sickness', cell_name, false, {})
