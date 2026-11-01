extends Node

# components
@onready var parent_station_detacher : Node3D = $"../../.."
@onready var compute_validity : Node = $ComputeValidity
@onready var refresh_displays : Node = $"../../RefreshDisplays"

var cycle_values : Array[String] = ['strength', 'intelligence', 'community']

func _handle(direction : int) : 
	
	if not parent_station_detacher.enabled : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed') 
		return
	
	if not parent_station_detacher.loaded_cell_container : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed') 
		return
	
	GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
	
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

	else : 
		
		var loaded_cell : BrainCell = parent_station_detacher._get_loaded_cell()
		
		parent_station_detacher.stat_selected_index = next_stat_selected_index
		parent_station_detacher.selected_stat =  cycle_values[next_stat_selected_index]
		parent_station_detacher.stat_valid = compute_validity._compute(loaded_cell, cycle_values[next_stat_selected_index])
		
		if parent_station_detacher.stat_valid :
			parent_station_detacher.failure_rate = GAMEFailureChance.detacher_helper._get_stat_failure_chance(loaded_cell, cycle_values[next_stat_selected_index])
		else : 
			parent_station_detacher.failure_rate = 0.0
		
		# TODO valaidity and failure rate

	refresh_displays._refresh()
