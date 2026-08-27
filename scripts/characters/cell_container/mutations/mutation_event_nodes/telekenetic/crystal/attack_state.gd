
extends Node


# Components
@onready var parent_crystal_body: CharacterBody3D = $"../.."
@onready var detect_coll_area : Area3D = $"../../DetectCollisionArea"

var player: CharacterBody3D
var move_direction: Vector3 = Vector3.ZERO

var state_active: bool = false
var homing_finished: bool = false

var time_alive: float = 0.0


@export var bullet_speed: float = 10.0

# How long the bullet travels normally before slightly homing.
@export var homing_delay: float = 2.0

# How long the bullet is allowed to adjust toward the player.
@export var homing_duration: float = 0.5

# Keep this low for subtle homing.
@export var homing_strength: float = 0.25


func state_start() -> void:
	state_active = true
	homing_finished = false
	time_alive = 0.0

	player = GLPlayerState.player_refrence

	if not is_instance_valid(player):
		push_error("Homing crystal could not find player.")
		state_active = false
		return

	# Fire toward the player's position when the state begins.
	move_direction = (
		parent_crystal_body.global_position.direction_to(
			player.global_position
		)
	)

	detect_coll_area.set_collision_mask_value(1, true)
	detect_coll_area.set_collision_mask_value(2, true)
	detect_coll_area.set_collision_mask_value(3, true)
	


func state_process(delta: float) -> void:
	if not state_active:
		return

	if move_direction.is_zero_approx():
		return

	time_alive += delta

	var homing_start_time: float = homing_delay
	var homing_end_time: float = (
		homing_delay + homing_duration
	)

	var inside_homing_period: bool = (
		time_alive >= homing_start_time
		and time_alive < homing_end_time
		and not homing_finished
	)

	if inside_homing_period and is_instance_valid(player):
		var direction_to_player: Vector3 = (
			parent_crystal_body.global_position.direction_to(
				player.global_position
			)
		)

		# Do not turn around after passing the player.
		var player_is_in_front: bool = (
			move_direction.dot(direction_to_player) > 0.0
		)

		if player_is_in_front:
			move_direction = move_direction.slerp(
				direction_to_player,
				clampf(
					homing_strength * delta,
					0.0,
					1.0
				)
			).normalized()
		else:
			homing_finished = true

	elif time_alive >= homing_end_time:
		# Preserve the final direction forever.
		homing_finished = true

	parent_crystal_body.velocity = (
		move_direction * bullet_speed
	)

	parent_crystal_body.move_and_slide()


func state_end() -> void:
	state_active = false
	homing_finished = true
	time_alive = 0.0
	move_direction = Vector3.ZERO

	parent_crystal_body.velocity = Vector3.ZERO
