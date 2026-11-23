extends RandomMutationEventListener

func _ready() -> void:
	GLEntityRoomManagementBus.connect('entity_changed_room', _handle_entity_changed_room)
	
	# starts in main room
	_handle_entity_changed_room(parent_cell_container.designated_brain_cell.name, 'main_room')
	
	
func _handle_entity_changed_room(entity_name : String, room_name : String) :
	
	for entity_profile : EntityRoomProfile in GLEntityRoomManagementBus.entity_room_profiles :
		if entity_profile.entity_type == 'cell_container' :
			if entity_profile.entity_name == entity_name:
				if room_name == 'main_room'  or room_name == 'interpreter_room' :
					_toggle_mutation_event_situation_increase(true, designated_mutation_event.mutation_name, designated_mutation_event.event_name)
				else : 
					_toggle_mutation_event_situation_increase(false, designated_mutation_event.mutation_name, designated_mutation_event.event_name)
			
