extends Node

# old ones 
signal breeding_station_feedback_requested(side : String, type : String)
signal play_sound_skull_warning(side : String)

signal toggle_show_view_breeder_label(toggle_value : bool)

# new ones
signal toggle_cell_entry_border(cell_name : String, border_type : String, toggle_value : bool)
signal breeder_play_sound(sound_type : String)
