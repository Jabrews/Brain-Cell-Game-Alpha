extends Node

# componentd
@onready var parent_station_attacher : Node3D = $"../../.."
@onready var init_success_attach : Node = $InitSuccessDetach
@onready var init_fail_attach : Node =$InitFailDetach

func _handle() : 
	
	
	##### Fail Cases ######	
	
	if not parent_station_attacher.enabled : 
		GLAttacherComponentBus.emit_signal('play_sound', 'confirm_failed')
		return
	
	if not parent_station_attacher.loaded_cell_container : 
		GLAttacherComponentBus.emit_signal('play_sound', 'confirm_failed')
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
		GLAttacherComponentBus.emit_signal('play_sound', 'confirm_failed')
		return
	
	########################	
	

	# get needed properties
	var loaded_cell : BrainCell = parent_station_attacher._get_loaded_cell()
	var failure_rate : int = parent_station_attacher.failure_rate # for rolling
	
	var ran_num = randi_range(0, 100)
	
	
	# failed (make sure its enabled)
	if ran_num <= failure_rate and parent_station_attacher.failure_rate_enabled : 
		
		init_fail_attach._failed(
			loaded_cell,
			main_stat_replacement_state,
			failure_rate
		)
		
		#init_success_attach._success(
			#loaded_cell,
			#main_stat_replacement_state,
		#)
	
	# success
	else : 	
		init_fail_attach._failed(
			loaded_cell,
			main_stat_replacement_state,
			failure_rate
		)
		
		#init_success_attach._success(
			#loaded_cell,
			#main_stat_replacement_state,
		#)
	
	GLDetacherComponentBus.emit_signal('play_sound', 'finished')
	
	


	
