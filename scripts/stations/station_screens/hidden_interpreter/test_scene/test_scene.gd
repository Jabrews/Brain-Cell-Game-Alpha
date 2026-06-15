extends Node

# componnets
@onready var game_screen_timer : Node2D = $GameScreenTimer
@onready var interpreter_station_parent : Node3D = $"../../../../.." 

func _handle_increment(current_value : int) :
	game_screen_timer._handle_increment(current_value)

func point_collected(point_amount : int) :
	# creating falling label on timer
	game_screen_timer._handle_point_collected(point_amount)
	# let parent station know to correct timer
	interpreter_station_parent._handle_point_collected(point_amount)
	
	
	
