extends CharacterBody3D 

class_name FleshBug

# componnets
@export var detect_player_area : Area3D 
@export var state_machine : Node 
@export var s_hit_sound : AudioStreamPlayer3D

# class vars
@export var entity_health : int 
@export var knockback_min : float = 0.2
@export var knockback_max : float = 0.8



func _ready() -> void:
	detect_player_area.connect('body_entered', _handle_detect_player_body_entered)
	detect_player_area.connect('body_exited', _handle_detect_player_body_exited)
	
func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	
	
## State Machine Switching to attack player ##
func _handle_detect_player_body_entered(body : Node3D) :
	
	# prevent state switching when dying	
	if state_machine.curr_state.name == 'Dying' :
		return
	
	if body.is_in_group('player') :
		state_machine.switch_state(state_machine.State.ATTACK)		

func _handle_detect_player_body_exited(body : Node3D) :
	
	# prevent state switching when dying	
	if state_machine.curr_state.name == 'Dying' :
		return
	
	if body.is_in_group('player') :
		state_machine.switch_state(state_machine.State.FOLLOW_PLAYER)		
###############################################

func take_damange(damage_amount : int, player_global_pos : Vector3) :
	entity_health -= damage_amount
	
	if s_hit_sound :	
		s_hit_sound.play()
	
	# apply knockback
	apply_knockback(player_global_pos)
	
	# TODO : mabye theres room for a knockback state when it specified
	
	# check for death
	if entity_health <= 0 :
		state_machine.switch_state(state_machine.State.DYING)		

func apply_knockback(player_global_pos : Vector3) :

	var knockback_dir = global_position - player_global_pos
	knockback_dir.y = 0

	knockback_dir = knockback_dir.normalized()

	var knockback_amount : float = randf_range(knockback_min, knockback_max)

	velocity += knockback_dir * knockback_amount

	
