extends Area2D


func _ready() -> void:
	connect('body_entered' , _handle_body_entered)

func _handle_body_entered(body : Node2D) :
	if body.is_in_group('player') : 
		body._handle_ship_hit()
