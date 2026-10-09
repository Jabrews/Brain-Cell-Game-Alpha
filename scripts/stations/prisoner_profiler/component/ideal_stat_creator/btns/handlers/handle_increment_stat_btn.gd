extends Node

# parent  
@onready var parent_ideal_stat_creator : Node = $"../.."
	
func _handle(increment_direction : String) :
	
	# exit case 1	
	if not parent_ideal_stat_creator.enabled  : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	# exit case 2
	var selected_stat : String	= parent_ideal_stat_creator.selected_stat 
	
	if selected_stat == 'none' : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
		
	# get value increment
	var ideal_value_increment : float 
	match increment_direction : 
		'up' :
			ideal_value_increment = 10
		'down': 
			ideal_value_increment = -10
	
	# get current stat value
	var current_ideal_stat_value = parent_ideal_stat_creator.ideal_stats_value[selected_stat]
	
	# find new
	var new_ideal_stat_value : float = current_ideal_stat_value + ideal_value_increment
	
	# propigate to parent
	parent_ideal_stat_creator._set_ideal_stat_value(selected_stat, new_ideal_stat_value)
		
		
	
	
	
