extends CharacterBody2D 

var x_move_direction = 1

@export var horizontal_speed = 50
@export var vertical_speed = 50

var last_position 

# components 
@onready var sprite : Sprite2D = $Sprite
@onready var spawn_ghost_delay : Timer = $SpawnGhostDelay


func _ready() -> void:
	pick_starting_direction()	
	
	sprite.material = sprite.material.duplicate()
	last_position = global_position

	# TODO 
	#spawn_ghost_delay.connect('timeout', _spawn_ghost_timeout)
	#spawn_ghost_delay.start()


	
	
func _process(_delta: float) -> void:
	
	# move to the move direction	
	velocity.x = x_move_direction * horizontal_speed
	velocity.y = 1 * vertical_speed
	
	
	move_and_slide()
	
	
# TODO 
#func _spawn_ghost_timeout() :
	#pass
	
	
func pick_starting_direction() :
	var random_num = randi_range(0, 100)
	if random_num >= 50 : 
		x_move_direction = 1
	else : 
		x_move_direction = -1
