extends Node
		
		
func _ready() -> void:
	
	# management signals
	GLGameManagerBus.connect('process_next_round', _handle_process_next_round)
	GLCellManagerBus.connect('delete_selected_collected_cell', _handle_delete_selected_collected_cell)
	GLCellManagerBus.connect('prisoner_picked_by_player', _handle_prisoner_picked_by_player)
	GLCellManagerBus.connect('cell_breeded', _handle_cell_breeded)
	
	# room entrance area signal
	GLEntityRoomManagementBus.connect('entity_changed_room', _handle_entity_changed_room)
	
	
	# put player in by default
	GLEntityRoomManagementBus.entity_room_profiles.append(
		EntityRoomProfile.new(
			'player',
			'player',
			'prisoner_room'
		)
	)
	
func _handle_process_next_round() :
	# reset
	GLEntityRoomManagementBus.entity_room_profiles = []
	# add player at spawn
	GLEntityRoomManagementBus.entity_room_profiles.append(
		EntityRoomProfile.new(
			'player',
			'player',
			'prisoner_room'
		)
	)

			
func _handle_delete_selected_collected_cell(brain_cell : BrainCell) :
	for room_profile : EntityRoomProfile in GLEntityRoomManagementBus.entity_room_profiles:
		if room_profile.entity_name == brain_cell.name:
			GLEntityRoomManagementBus.entity_room_profiles.erase(room_profile)
	
	
func _handle_prisoner_picked_by_player(brain_cell : BrainCell) :
	
	GLEntityRoomManagementBus.entity_room_profiles.append(
		EntityRoomProfile.new(
			'cell_container',
			brain_cell.name,
			'main_room'
		)
	)
	
func _handle_entity_changed_room(target_entity_name : String, new_room_name : String) :
	for room_profile : EntityRoomProfile in GLEntityRoomManagementBus.entity_room_profiles:
		if room_profile.entity_name == target_entity_name:
			room_profile.room_name = new_room_name
	
	
func _handle_cell_breeded(_cell_1, _cell_2, new_cell : BrainCell, _cell_3, _cell_4_, _kill_cell_1, _kill_cell_2) : 
	GLEntityRoomManagementBus.entity_room_profiles.append(
		EntityRoomProfile.new(
			'cell_container',
			new_cell.name,
			'main_room'
		)
	)
	
		
