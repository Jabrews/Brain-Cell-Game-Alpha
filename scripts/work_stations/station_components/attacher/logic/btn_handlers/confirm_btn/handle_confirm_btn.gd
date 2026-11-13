extends Node

# componentd
@onready var parent_station_attacher : Node3D = $"../../.."
@onready var init_success_detach : Node = $InitSuccessDetach
@onready var init_fail_detach : Node = $InitFailDetach

func _handle() : 
	
	
	##### Fail Cases ######	
	
	if not parent_station_attacher.enabled : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed') 
		return
	
	if not parent_station_attacher.loaded_cell_container : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed') 
		return
	
	
	## find valid change
	var main_stat_replacement_state: Dictionary[String, StatJarItem] = GLAttacherComponentBus.main_stat_replacement_state

	var found_valid_change: bool = false

	for key: String in main_stat_replacement_state:
		var replacement_jar_item: StatJarItem = main_stat_replacement_state[key]

		if replacement_jar_item:
			found_valid_change = true
			break
	
	if not found_valid_change: 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed') 
		return
	
	########################	
	
	GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')

	# get needed properties
	var loaded_cell : BrainCell = parent_station_attacher._get_loaded_cell()
	var failure_rate : int = parent_station_attacher.failure_rate # for rolling
	
	var ran_num = randi_range(0, 100)
	
	
	# failed (make sure its enabled)
	if ran_num <= failure_rate and parent_station_attacher.failure_rate_enabled : 
		
		#init_fail_detach._failed(
			#loaded_cell,
			#main_stat_replacement_state,
			#failure_rate
		#)
		
		init_success_detach._success(
			loaded_cell,
			main_stat_replacement_state,
		)
	
	# success
	else : 	
		#init_fail_detach._failed(
			#loaded_cell,
			#main_stat_replacement_state,
			#failure_rate
		#)
		
		init_success_detach._success(
			loaded_cell,
			main_stat_replacement_state,
		)
	
	GLDetacherComponentBus.emit_signal('play_sound', 'finished')
	
	


	
