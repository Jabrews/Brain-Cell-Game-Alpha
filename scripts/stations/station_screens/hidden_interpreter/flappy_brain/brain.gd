extends CharacterBody2D


var idle_float_active : bool = true

@export var gravity: float = 800.0
@export var jump_force: float = -250.0
@export var max_fall_speed: float = 500.0

# componnets
@onready var idle_float_jump_delay : Timer = $IdleFloatJumpDelay


func _physics_process(delta: float) -> void:
	
	# Gravity pulls the player down
	velocity.y += gravity * delta

	# Limit fall speed
	velocity.y = min(velocity.y, max_fall_speed)

	# regular movement
	if not idle_float_active :

		# Flappy Bird jump
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_force

	move_and_slide()

func toggle_idle_float(toggle_value  :bool) :
	
	idle_float_active = toggle_value	
	
	if toggle_value : 		
		idle_float_jump_delay.start()
		# quick jump
		velocity.y = jump_force
	if not toggle_value :
		idle_float_jump_delay.stop()
		
	
func _on_idle_float_jump_delay_timeout() -> void:
	velocity.y = jump_force
	
	move_and_slide()
		
func reset() :
	position = Vector2(223.0, 138.0)
	velocity = Vector2.ZERO
	
	
