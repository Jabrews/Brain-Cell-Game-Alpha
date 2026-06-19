extends Node

# componnets 
@onready var game_screen_timer : Node2D =  $GameScreenTimer

var total_points_collected : int = 0


func _ready() -> void:
	GLInterpreterGames.connect('ship_collected_point', _handle_ship_collected_point)
	GLInterpreterGames.connect('parent_ship_died', _handle_parent_ship_died)


func _handle_increment(current_time_increment : int) :
	game_screen_timer.call_deferred("_handle_increment", current_time_increment)

func _handle_ship_collected_point(point_amount : int) :
	total_points_collected += point_amount
	game_screen_timer.call_deferred("_handle_point_collected", point_amount)

func _handle_parent_ship_died() : 
	queue_free()
	
