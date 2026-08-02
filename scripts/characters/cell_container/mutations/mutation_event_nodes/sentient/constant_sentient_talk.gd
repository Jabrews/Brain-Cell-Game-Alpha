
extends MutationNode

@onready var speech_bubble : Node3D = $SpeechBubble
@onready var get_new_dialouge_delay_timer : Timer = $GetNewDialougeDelayTimer
@onready var check_if_player_entered_room_timer : Timer = $CheckIfPlayerEnteredRoomTimer
@onready var play_near_death_event_dialouge_timer : Timer = $PlayNearDeathEventDialouge


@onready var screen_text_speech_bubble : Control = $SpeechBubble/SpeechBubbleTV/SubViewport/ScreenTextSpeechBubble

var saved_dialouge : Sentient_Dialogue

var waiting_for_player_to_enter_room : bool = false
var waiting_to_play_dialouge : bool = false

@export var hide_distance: float = 1.7

func _process(_delta: float) -> void:
	var player: Node3D = GLPlayerState.player_refrence

	if player == null:
		return

	var distance_to_player: float = global_position.distance_to(
		player.global_position
	)

	if distance_to_player <= hide_distance:
		screen_text_speech_bubble.modulate.a = 0.7
	else:
		screen_text_speech_bubble.modulate.a = 1.0
	
	
func _ready_overide() :
	random_event = false
	stop_on_pickup = false
	
	get_new_dialouge_delay_timer.one_shot = true
	check_if_player_entered_room_timer.one_shot = true
	
	# timer connects
	get_new_dialouge_delay_timer.connect('timeout', _handle_get_new_dialouge_delay_timeout)
	check_if_player_entered_room_timer.connect('timeout', _handle_check_if_player_entered_room_timeout)
	play_near_death_event_dialouge_timer.connect('timeout', _handle_play_near_death_event_dialouge_timer)
	
	
	# event interuptors connect	
	GLMutationSentientState.connect('toggle_cell_near_death_event', _handle_toggle_cell_near_death_event)
	GLMutationSentientState.connect('item_used_on_cell', _handle_item_used_on_cell)
	


func _start() :
	
	reveal_mutation()	
	
	start_new_dialouge_timer()


func start_new_dialouge_timer() :
	get_new_dialouge_delay_timer.wait_time = randi_range(60, 300) # 60 - 300
	get_new_dialouge_delay_timer.start()


func _handle_get_new_dialouge_delay_timeout() :
	# Save a dialouge so the same one is used when the player enters the room.
	if saved_dialouge == null :
		saved_dialouge = GLMutationSentientState._get_sentient_dialouge()
	
	# If we have used all dialouge, stop.
	if saved_dialouge == null :
		get_new_dialouge_delay_timer.stop()
		check_if_player_entered_room_timer.stop()
		return
#	
	# If player is not in the same room, repeatedly check until they enter.
	if not verify_player_in_same_room_as_cell() :
		waiting_for_player_to_enter_room = true
		waiting_to_play_dialouge = false
		
		check_if_player_entered_room_timer.wait_time = 2.0
		check_if_player_entered_room_timer.start()
		return
	
	# Player is already in the room.
	start_dialouge_entry_delay()


func _handle_check_if_player_entered_room_timeout() :
	# We are checking until the player enters the room.
	if waiting_for_player_to_enter_room :
		if verify_player_in_same_room_as_cell() :
			waiting_for_player_to_enter_room = false
			start_dialouge_entry_delay()
			return
		
		check_if_player_entered_room_timer.wait_time = 2.0
		check_if_player_entered_room_timer.start()
		return
	
	# The player entered the room and the 5-10 second pause has finished.
	if waiting_to_play_dialouge :
		waiting_to_play_dialouge = false
		
		# Check again in case the player left during the delay.
		if not verify_player_in_same_room_as_cell() :
			waiting_for_player_to_enter_room = true
			
			check_if_player_entered_room_timer.wait_time = 2.0
			check_if_player_entered_room_timer.start()
			return
		
		await play_saved_dialouge()


func start_dialouge_entry_delay() :
	waiting_for_player_to_enter_room = false
	waiting_to_play_dialouge = true
	
	check_if_player_entered_room_timer.wait_time = randi_range(5, 10)
	check_if_player_entered_room_timer.start()


func play_saved_dialouge() :
	if saved_dialouge == null :
		return
	
	# Send to speech bubble and confirm it played.
	var dialouge_used : bool = await speech_bubble._start_text(
		saved_dialouge
	)
	
	# If it played, remove it from the state.
	if dialouge_used == true :
		GLMutationSentientState._remove_sentient_dialouge(
			saved_dialouge
		)
		
		saved_dialouge = null
		start_new_dialouge_timer()
		return
	
	# Speech bubble was busy.
	# Keep the saved dialouge and try again shortly.
	waiting_for_player_to_enter_room = true
	
	check_if_player_entered_room_timer.wait_time = 2.0
	check_if_player_entered_room_timer.start()


func verify_player_in_same_room_as_cell() -> bool :
	var cell_room_profile : EntityRoomProfile
	var player_room_profile : EntityRoomProfile
	
	# Find selected cell's room profile.
	for room_profile : EntityRoomProfile in GLEntityRoomManagementBus.entity_room_profiles :
		if room_profile.entity_type == 'cell_container' :
			if room_profile.entity_name == parent_cell_container.designated_brain_cell.name :
				cell_room_profile = room_profile
		
		if room_profile.entity_type == 'player' :
			player_room_profile = room_profile
	
	# Error catch.
	if not cell_room_profile :
		push_error(
			'unable to find cell room profile for cell container: ',
			parent_cell_container.designated_brain_cell.name
		)
		return false
	
	if not player_room_profile :
		push_error('unable to find player room profile')
		return false
	
	if cell_room_profile.room_name == player_room_profile.room_name :
		return true
	
	return false

func _handle_toggle_cell_near_death_event(toggle_value : bool, cell_name : String) :
	if cell_name == parent_cell_container.designated_brain_cell.name :
		if toggle_value :
			check_if_player_entered_room_timer.stop()
			get_new_dialouge_delay_timer.stop()
			_handle_play_near_death_event_dialouge_timer()
		else :
			get_new_dialouge_delay_timer.start()
			play_near_death_event_dialouge_timer.stop()
			speech_bubble._fade_bubble_out()
	
		
func _handle_play_near_death_event_dialouge_timer(): 
	play_near_death_event_dialouge_timer.start()
	var near_death_dialouge : Sentient_Dialogue = GLMutationSentientState._get_near_death_dialouge()
	var _dialouge_used : bool = await speech_bubble._start_text(near_death_dialouge, true)		
	
		

func _handle_item_used_on_cell(item_type : String, cell_name : String) :
	if cell_name == parent_cell_container.designated_brain_cell.name : 
		
		# shot event
		if item_type == 'defect_shot' or item_type == 'hidden_shot' :
			var thanks_dialouge : Sentient_Dialogue = GLMutationSentientState._get_shot_thanks_dialouge()
			var _dialouge_used : bool = await speech_bubble._start_text(thanks_dialouge, true)		
	
	


func _stop() :
	get_new_dialouge_delay_timer.stop()
	check_if_player_entered_room_timer.stop()
	
	waiting_for_player_to_enter_room = false
	waiting_to_play_dialouge = false
	saved_dialouge = null
	
	print('sentient stop')
