extends Node


func _get_possible() -> Array[PossibleMutationEventChoice] :
	var possible_mutation_event_choices : Array[PossibleMutationEventChoice] = []
	
	
	var collected_cells : Array[BrainCell]	= GLCellManagerBus.collected_cells_refrence
	
	for cell : BrainCell in collected_cells :
		
		# if round 1-2 complelty ignore cells in diffrent room	
		var cell_room_valid = verify_cell_room_valid(cell.name)
		if not cell_room_valid and GLGameManagerBus.current_round <= 2 :
			# should not worry about this cell
			#print('found invalid choice')
			continue
		
		# search for random mutations
		if len(cell.mutations) > 0 :
			for mutation : BrainCellMutation in cell.mutations :
				for mutation_event in mutation.mutation_events :
					# only use random events
					if mutation_event.event_type == 'random_event' :
						# creatre choice
						possible_mutation_event_choices.append(
							PossibleMutationEventChoice.new(mutation_event, cell, cell_room_valid)
						)
						
	return possible_mutation_event_choices
	
	
func verify_cell_room_valid(cell_name : String) -> bool : 	
	var room_profiles : Array[EntityRoomProfile] = GLEntityRoomManagementBus.entity_room_profiles
	
	var cell_room_profile : EntityRoomProfile	
	var player_room_profile : EntityRoomProfile
	
	# get correct room profiles
	for room_profile : EntityRoomProfile in room_profiles : 	
		# cell corrisponding cell room profile
		if room_profile.entity_type == 'cell_container' :
			if room_profile.entity_name == cell_name :
				cell_room_profile = room_profile 
		# get player room profile
		if room_profile.entity_type == 'player' :
			if room_profile.entity_name == 'player':
				player_room_profile = room_profile 
	
	if not cell_room_profile or not player_room_profile : 
		push_error('unable to find cell or player room profile :', cell_room_profile, player_room_profile)
	
	# check if rooms are the same
	if cell_room_profile.room_name == player_room_profile.room_name : 
		return true
	else : 
		return false 
	
	
				
			
				
	
	
	
	
	
	
	
	
