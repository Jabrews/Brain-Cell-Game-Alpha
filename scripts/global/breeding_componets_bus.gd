extends Node

# old ones 
signal breeding_station_feedback_requested(side : String, type : String)
signal play_sound_skull_warning(side : String)

signal toggle_show_view_breeder_label(toggle_value : bool)

# new ones
# border stuff for cell entrties and boxes
signal toggle_cell_entry_border(cell_name : String, border_type : String, is_wanted : bool)
signal toggle_cell_box_border(box_type : String, box_side : String, is_wanted : bool)
signal reset_borders() # both entry and box
# communicating to boost box
signal toggle_boost_activated(side : String, toggle_value : bool)

signal breeder_play_sound(sound_type : String)
# IMPORTANT
signal initate_breeder_refresh()

# goes to cells
signal toggle_wanted_highlight(toggle_value : bool, cell_name : String, highlight_type : String)

# communicating to and fro boxes
signal cell_loaded_on_selected_view(cell : BrainCell)
signal cell_removed_from_selected_view()

# updating stat display. dealing with boost without refreshing
signal refresh_stat_display()


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



var left_boost_stat : String = 'none'
var right_boost_stat : String = 'none'
var left_boost_direction : String = 'none'
var right_boost_direction : String = 'none'


var reasons_confirm_invalid : Array[String] = []
