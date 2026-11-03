extends Node

# componentd
@onready var parent_station_detacher : Node3D = $"../../../.."
@onready var init_success_detach : Node = $InitSuccessDetach

func _handle() : 
	
	if not parent_station_detacher.enabled : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed') 
		return
	
	if not parent_station_detacher.loaded_cell_container : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed') 
		return
	
	if not parent_station_detacher.stat_valid : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed') 
		return
	
	GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')

	# get needed properties
	var loaded_cell : BrainCell = parent_station_detacher._get_loaded_cell()
	var selected_stat : String = parent_station_detacher.selected_stat
	var failure_rate : int = parent_station_detacher.failure_rate # for rolling
	
	var ran_num = randi_range(0, 100)
	
	# failed 
	if ran_num <= failure_rate : 
		# TODO FIX we tell it what to do depending on what range it existied inside of	
		
		init_success_detach._success(
			loaded_cell,
			selected_stat,
		)
	
	# success
	else : 	
		init_success_detach._success(
			loaded_cell,
			selected_stat,
		)
	
	
	
	


	
