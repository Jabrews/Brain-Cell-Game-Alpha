extends Node


# Components
@onready var parent_slug: CharacterBody3D = $"../.."
@onready var worm_moving_sound: AudioStreamPlayer3D = (
	$"../../WormMovingSound"
)
@onready var state_machine: Node = $".."
@onready var nav_agent: NavigationAgent3D = $"../../FloorNavAgent"
@onready var movement_delay_timer: Timer = $MovementDelayTimer


var player_refrence: CharacterBody3D

var state_active: bool = false
var currently_inching: bool = false
var forcing_movement: bool = false

var last_checked_position: Vector3 = Vector3.ZERO
var forced_direction: Vector3 = Vector3.ZERO

var stuck_check_timer: Timer
var force_movement_timer: Timer


@export var inch_speed: float = 12.0
@export var inch_move_time: float = 0.15
@export var time_between_inches: float = 0.5

# Stuck detection
@export var stuck_check_time: float = 2.0
@export var stuck_distance_threshold: float = 0.1

# Small forced push toward the player
@export var force_movement_duration: float = 0.25
@export var force_movement_speed: float = 2.0


func _ready() -> void:
	movement_delay_timer.timeout.connect(
		_handle_movement_delay_timer_timeout
	)

	stuck_check_timer = Timer.new()
	stuck_check_timer.one_shot = false
	stuck_check_timer.wait_time = stuck_check_time
	stuck_check_timer.timeout.connect(
		_handle_stuck_check_timer_timeout
	)
	add_child(stuck_check_timer)

	force_movement_timer = Timer.new()
	force_movement_timer.one_shot = true
	force_movement_timer.wait_time = force_movement_duration
	force_movement_timer.timeout.connect(
		_handle_force_movement_timer_timeout
	)
	add_child(force_movement_timer)


func state_start() -> void:
	state_active = true
	currently_inching = false
	forcing_movement = false

	player_refrence = GLPlayerState.player_refrence

	last_checked_position = parent_slug.global_position

	stuck_check_timer.wait_time = stuck_check_time
	stuck_check_timer.start()


func state_process(_delta: float) -> void:
	if not state_active:
		return

	if not is_instance_valid(player_refrence):
		player_refrence = GLPlayerState.player_refrence

		if not is_instance_valid(player_refrence):
			movement_delay_timer.stop()
			parent_slug.velocity.x = 0.0
			parent_slug.velocity.z = 0.0
			return

	if forcing_movement:
		parent_slug.velocity.x = (
			forced_direction.x * force_movement_speed
		)

		parent_slug.velocity.z = (
			forced_direction.z * force_movement_speed
		)

		parent_slug.move_and_slide()
		return

	if (
		movement_delay_timer.is_stopped()
		and not currently_inching
	):
		movement_delay_timer.start()


func _handle_movement_delay_timer_timeout() -> void:
	if not state_active:
		return

	if forcing_movement or currently_inching:
		return

	if not is_instance_valid(player_refrence):
		return

	currently_inching = true

	worm_moving_sound.play()

	await inch_towards_player()

	if not state_active:
		currently_inching = false
		return

	await get_tree().create_timer(
		time_between_inches
	).timeout

	if not state_active:
		currently_inching = false
		return

	await inch_towards_player()

	currently_inching = false

	if state_active:
		movement_delay_timer.start()


func inch_towards_player() -> void:
	if not state_active:
		return

	if forcing_movement:
		return

	if not is_instance_valid(player_refrence):
		return

	var safe_target: Vector3 = (
		NavigationServer3D.map_get_closest_point(
			nav_agent.get_navigation_map(),
			player_refrence.global_position
		)
	)

	nav_agent.target_position = safe_target

	var destination: Vector3 = (
		nav_agent.get_next_path_position()
	)

	var direction: Vector3 = (
		destination - parent_slug.global_position
	)

	direction.y = 0.0

	if direction.is_zero_approx():
		parent_slug.velocity.x = 0.0
		parent_slug.velocity.z = 0.0
		return

	direction = direction.normalized()

	var look_position: Vector3 = destination
	look_position.y = parent_slug.global_position.y

	if not parent_slug.global_position.is_equal_approx(
		look_position
	):
		parent_slug.look_at(
			look_position,
			Vector3.UP
		)

	parent_slug.velocity.x = direction.x * inch_speed
	parent_slug.velocity.z = direction.z * inch_speed

	var elapsed: float = 0.0

	while elapsed < inch_move_time:
		if not state_active or forcing_movement:
			break

		parent_slug.move_and_slide()

		await get_tree().physics_frame

		elapsed += get_physics_process_delta_time()

	parent_slug.velocity.x = 0.0
	parent_slug.velocity.z = 0.0


func _handle_stuck_check_timer_timeout() -> void:
	if not state_active:
		return

	if forcing_movement:
		return

	if not is_instance_valid(parent_slug):
		return

	if not is_instance_valid(player_refrence):
		return

	var current_position: Vector3 = parent_slug.global_position

	var distance_moved: float = current_position.distance_to(
		last_checked_position
	)

	last_checked_position = current_position

	if distance_moved > stuck_distance_threshold:
		return

	# Apply a small horizontal push directly toward the player.
	forced_direction = (
		player_refrence.global_position
		- parent_slug.global_position
	)

	forced_direction.y = 0.0

	if forced_direction.is_zero_approx():
		return

	forced_direction = forced_direction.normalized()

	forcing_movement = true

	force_movement_timer.wait_time = force_movement_duration
	force_movement_timer.start()


func _handle_force_movement_timer_timeout() -> void:
	forcing_movement = false

	parent_slug.velocity.x = 0.0
	parent_slug.velocity.z = 0.0

	last_checked_position = parent_slug.global_position


func state_end() -> void:
	state_active = false
	currently_inching = false
	forcing_movement = false

	movement_delay_timer.stop()
	stuck_check_timer.stop()
	force_movement_timer.stop()

	parent_slug.velocity = Vector3.ZERO

	player_refrence = null

	worm_moving_sound.stop()


func _exit_tree() -> void:
	if is_instance_valid(parent_slug):
		parent_slug.velocity = Vector3.ZERO
