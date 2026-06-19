extends CharacterBody2D

var bullet_speed : float = 0
@onready var delete_timer : Timer = $DeleteTimer
@onready var detect_astroid_area : Area2D = $DetectAstroidArea

func _ready() -> void:
	
	bullet_speed = IVAstroidBrain.bullet_speed	
	
	delete_timer.connect('timeout', _handle_delete_timeout)	
	detect_astroid_area.connect('body_entered', _handle_detect_astroid_area_body_entered)
	
	
func _process(_delta: float) -> void:
	
	velocity.y = bullet_speed *	-1 # up
	
	move_and_slide()
	
func _handle_delete_timeout() :
	queue_free()

func _handle_detect_astroid_area_body_entered(body : Node2D):
	if body.is_in_group('astroid') :
		body._handle_hit_by_bullet()
		# kill bullet
		queue_free()
	
	
	if body.is_in_group('bubble') :
		body.kill_bubble()
		GLInterpreterGames.emit_signal('ship_collected_bubble')
		queue_free()
		# kill bullet
		
		
		
	
	
	


		
	
	
