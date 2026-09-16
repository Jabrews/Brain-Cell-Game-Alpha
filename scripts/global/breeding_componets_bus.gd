extends Node

# old ones 
signal breeding_station_feedback_requested(side : String, type : String)
signal play_sound_skull_warning(side : String)

signal toggle_show_view_breeder_label(toggle_value : bool)

# new ones
signal toggle_cell_entry_border(cell_name : String, border_type : String, is_wanted : bool)
signal toggle_cell_box_border(box_type : String, box_side : String, is_wanted : bool)
signal reset_borders() # both entry and box

signal breeder_play_sound(sound_type : String)
signal initate_breeder_refresh()

signal toggle_wanted_highlight(toggle_value : bool, cell_name : String, highlight_type : String)


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

var reasons_confirm_invalid : Array[String] = []
