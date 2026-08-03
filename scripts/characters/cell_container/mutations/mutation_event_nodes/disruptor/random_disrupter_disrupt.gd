extends MutationNode 

# particle componennt
@onready var particle_manager : Node3D = $ParticleManager
# sounds componennts
@onready var s_disrupt_start: AudioStreamPlayer3D = $Sounds/DisruptStart
@onready var s_disrupt_failed: AudioStreamPlayer3D = $Sounds/DisruptFailed
@onready var s_disrupt_success: AudioStreamPlayer3D = $Sounds/DisruptSuccess
# status labels componenents
@onready var hack_success_label : Label3D = $HackSuccess
@onready var hack_failed_label : Label3D = $HackFailed
# timer components
@onready var warning_disruptor_screens_timer : Timer = $WarnDisruptorScreensTimer
# hint hack circle manager
@onready var hint_hack_circle_manager : Node3D = $HintHackCircleManager
# detect disruptable area
@onready var detect_disruptable_area : Area3D = $DetectDisruptable

func _ready_overide() :
	random_event = true
	stop_on_pickup = false
	
	# timer signal
	warning_disruptor_screens_timer.connect('timeout', _handle_warning_disruptor_screens_timer_timeout)
	
	
func _start() :
	
	unhide_mutation()
	
	# play particles and sound
	s_disrupt_start.play()	
	particle_manager._start()
	
	# toggle warning componnets
	toggle_warning_disruptor(true)
	
	# activate seatch area
	detect_disruptable_area._search()
	
	# duration of warning
	await get_tree().create_timer(4.0).timeout
	
	# stop particles and sound
	particle_manager._stop()
	particle_manager.visible = false
	
	# toggle warning componnets
	toggle_warning_disruptor(false)
	
	
	
	var found_disruptable_recievers : Array[Area3D] = detect_disruptable_area.found_disruptable_receivers 
	
	# fail
	if len(found_disruptable_recievers) <= 0 : 
		s_disrupt_failed.play()
		hack_failed_label._start_blink()
	# success	
	else : 
		s_disrupt_success.play()
		hack_success_label._start_blink()
		_activate_disruptable_recievers(found_disruptable_recievers)
	
	await get_tree().create_timer(3.0).timeout
	
	random_event_finished()

func _handle_warning_disruptor_screens_timer_timeout() :
	
	var entity_room_profiles : Array[EntityRoomProfile] = GLEntityRoomManagementBus.entity_room_profiles
	
	var cell_container_name : String = parent_cell_container.designated_brain_cell.name
	var selected_room_profiler : EntityRoomProfile
	
	for room_profile : EntityRoomProfile in entity_room_profiles : 
		if room_profile.entity_name == cell_container_name : 
			selected_room_profiler = room_profile
	
	if not selected_room_profiler : 
		push_error('no room profile found for cell : ', cell_container_name)
	
	GLMutationDisruptState.emit_signal('disrupt_incoming', selected_room_profiler.room_name)
	

func toggle_warning_disruptor(toggle_value : bool) :
	if toggle_value : 	
		warning_disruptor_screens_timer.start()
		hint_hack_circle_manager._start()	
	if not toggle_value : 
		warning_disruptor_screens_timer.stop()
		GLMutationDisruptState.emit_signal('disrupt_ended')
		hint_hack_circle_manager._stop()	
	
func _activate_disruptable_recievers(disruptable_recievers : Array[Area3D]) :
	for disruptable_reciever in disruptable_recievers :
		disruptable_reciever._toggle_disrupt_manager(true)


	
func _stop() :
	pass
