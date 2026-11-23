extends Area2D


@export var flip_direction_x : bool = false

func _ready() -> void:
	connect('body_entered', _handle_body_entered)

func _handle_body_entered(body : Node2D) : 
	if body.is_in_group('hack_skull') :
		if flip_direction_x : 
			body.flip_direction('x')
		if not flip_direction_x : 
			body.flip_direction('y')
	
	
	
