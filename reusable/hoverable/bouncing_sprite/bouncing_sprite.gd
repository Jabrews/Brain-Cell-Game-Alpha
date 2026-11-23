extends AnimatedSprite3D 

## attach this to a scene of a animated sprite 3d
## the hoverable node will interact with this and instiate this scene

var bounce_loop = false


func _ready():
	visible = false


func show_bouncing_sprite():
	visible = true
	start_bounce()


func exit_bouncing_sprite():
	queue_free()


func start_bounce():
	var tween = create_tween()
	tween.set_loops() # infinite loop
	
	tween.tween_property(self, "position:y", position.y + 0.25, 0.5)
	tween.tween_property(self, "position:y", position.y - 0.25, 0.5)
