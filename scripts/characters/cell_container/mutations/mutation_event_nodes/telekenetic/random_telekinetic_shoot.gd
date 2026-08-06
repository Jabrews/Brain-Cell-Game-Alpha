extends MutationNode 

@onready var crystals_manager: Node3D = $CrystalManager
@onready var s_start : AudioStreamPlayer3D = $Start

func _ready_overide() :
	random_event = true
	stop_on_pickup = false 
	
func _start() :
	
	verify_player_in_same_room()
	
	# crystal idle 
	crystals_manager._create()
	
	unhide_mutation()
	
	
	s_start.play()
	
	await get_tree().create_timer(2.0).timeout
	
	# attack
	crystals_manager._attack_player()
	
	await get_tree().create_timer(10.0).timeout
	
	random_event_finished()

func verify_player_in_same_room(): 
	var room_profiles : Array[EntityRoomProfile] = GLEntityRoomManagementBus.entity_room_profiles
	
	var cell_name : String = parent_cell_container.designated_brain_cell.name
	
	var player_room: String 
	var container_room : String
	
	for room_profile : EntityRoomProfile in room_profiles : 
		if room_profile.entity_type == 'player' :
			player_room = room_profile.room_name
		
		if room_profile.entity_type == 'cell_container' : 
			if room_profile.entity_name == cell_name : 
				container_room = room_profile.room_name
	
	if player_room != container_room : 
		random_event_finished()
	
	
	
	


func _stop() :
	pass
