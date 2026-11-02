extends Node

# components
@onready var parent_station_detacher : Node3D = $"../../.."
@onready var compute_validity : Node = $ComputeValidity
@onready var refresh_displays : Node = $"../../RefreshDisplays"
@onready var light_manager : Node = $"../../LightManager"

var cycle_values : Array[String] = ['strength', 'intelligence', 'community']

func _handle(direction : int) : 
	
	if not parent_station_detacher.enabled : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed') 
		return
	
	if not parent_station_detacher.loaded_cell_container : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed') 
		return
	
	GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
	
	# no longer need to show just added screen on failure chance screen
	# hacky but it works
	parent_station_detacher.cell_just_added = false
	
	var curr_stat_selected_index : int = parent_station_detacher.stat_selected_index 
	
	var next_stat_selected_index : int = curr_stat_selected_index + direction
	
	# if going from none to up	
	if curr_stat_selected_index == -1 and direction == -1 : 
		next_stat_selected_index = 2
	
	# going to none
	if next_stat_selected_index > 2 or next_stat_selected_index < 0: 
		parent_station_detacher.stat_selected_index = -1
		parent_station_detacher.selected_stat = 'none'
		parent_station_detacher.stat_valid = false
		parent_station_detacher.failure_rate = 0.0
		light_manager._set_light_mode('red')

	else : 
		
		var loaded_cell : BrainCell = parent_station_detacher._get_loaded_cell()
		
		parent_station_detacher.stat_selected_index = next_stat_selected_index
		parent_station_detacher.selected_stat =  cycle_values[next_stat_selected_index]
		
		var stat_valid : bool = compute_validity._compute(loaded_cell, cycle_values[next_stat_selected_index])
		parent_station_detacher.stat_valid = stat_valid
		
		if stat_valid : 
			light_manager._set_light_mode('green')
		else : 
			light_manager._set_light_mode('red')
		
		if parent_station_detacher.stat_valid :
			parent_station_detacher.failure_rate = GAMEFailureChance.detacher_helper._get_stat_failure_chance(loaded_cell, cycle_values[next_stat_selected_index])
		else : 
			parent_station_detacher.failure_rate = 0.0
		
		# TODO valaidity and failure rate

	refresh_displays._refresh()
