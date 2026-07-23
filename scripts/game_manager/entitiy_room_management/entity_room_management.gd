extends Node
		
var entity_room_profiles: Array[EntityRoomProfile] = []
		
		
func _ready() -> void:
	
	# management signals
	GLGameManagerBus.connect('process_next_round', _handle_process_next_round)
	GLCellManagerBus.connect('delete_selected_collected_cell', _handle_delete_selected_collected_cell)
	GLCellManagerBus.connect('prisoner_picked_by_player', _handle_prisoner_picked_by_player)
	
	# room entrance area signal
	GLEntityRoomManagementBus.connect('entity_changed_room', _handle_entity_changed_room)
	
	
	
	# put player in by default
	entity_room_profiles.append(
		EntityRoomProfile.new(
			'player',
			'player',
			'prisoner_room'
		)
	)
	
func _handle_process_next_round() :
	# reset
	entity_room_profiles = []
	# add player at spawn
	entity_room_profiles.append(
		EntityRoomProfile.new(
			'player',
			'player',
			'prisoner_room'
		)
	)

			
func _handle_delete_selected_collected_cell(brain_cell : BrainCell) :
	for room_profile : EntityRoomProfile in entity_room_profiles :
		if room_profile.entity_name == brain_cell.name:
			entity_room_profiles.erase(room_profile)
	
	
func _handle_prisoner_picked_by_player(brain_cell : BrainCell) :
	
	entity_room_profiles.append(
		EntityRoomProfile.new(
			'cell_container',
			brain_cell.name,
			'main_room'
		)
	)
	
func _handle_entity_changed_room(target_entity_name : String, new_room_name : String) :
	for room_profile : EntityRoomProfile in entity_room_profiles :
		if room_profile.entity_name == target_entity_name:
			room_profile.room_name = new_room_name
	
	
		
		
		
