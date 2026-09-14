extends Node

# old ones 
signal breeding_station_feedback_requested(side : String, type : String)
signal play_sound_skull_warning(side : String)

signal toggle_show_view_breeder_label(toggle_value : bool)

# new ones
signal toggle_cell_entry_border(cell_name : String, border_type : String, toggle_value : bool)
signal breeder_play_sound(sound_type : String)
signal initate_breeder_refresh()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') :
		print(breeding_panel_state)
		print(breeding_ui_state)


var breeding_ui_state: Dictionary[String, BrainCell] = {
	'left_main' : null,
	'right_main' : null,
	'left_boost' : null,
	'right_boost' : null,
}

var breeding_panel_state : Dictionary[String, BrainCell] = {
	'left_main' : null,
	'right_main' : null,
	'left_boost' : null,
	'right_boost' : null,
}
