extends Node

# old ones 
signal breeding_station_feedback_requested(side : String, type : String)
signal play_sound_skull_warning(side : String)

var cell_names_bred_this_turn : Array[String] = []

# new ones
signal toggle_show_view_breeder_label(toggle_value : bool)
