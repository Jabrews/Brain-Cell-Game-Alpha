extends Area2D 

@export var flip_direction : String


func _ready() -> void:
	connect('body_entered', _handle_body_entered)

func _handle_body_entered(body : Node2D) :
	if body.is_in_group('astroid') or body.is_in_group('bubble'):
		if flip_direction == 'left' :
			body.x_move_direction = 1
		elif flip_direction == 'right' :
			body.x_move_direction = -1
		
		# bubble
		if body.is_in_group('bubble'):
			body.increment_wall_bump()
			
			
	
	
