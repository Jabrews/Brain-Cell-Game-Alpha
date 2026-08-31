extends Node

signal breeding_station_feedback_requested(side : String, type : String)
signal play_sound_skull_warning(side : String)

var cell_names_bred_this_turn : Array[String] = []
