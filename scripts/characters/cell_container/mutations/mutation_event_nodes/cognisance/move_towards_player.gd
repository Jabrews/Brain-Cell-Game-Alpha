extends Node


# Components
@onready var floor_nav_agent: NavigationAgent3D = $"../FloorNavAgent"

var parent_cell_container: CharacterBody3D
var player_reference: CharacterBody3D

var walking_towards_player: bool = false
var forcing_movement: bool = false

var last_checked_position: Vector3 = Vector3.ZERO
var forced_direction: Vector3 = Vector3.ZERO

var stuck_check_timer: Timer
var force_movement_timer: Timer


@export var walking_speed: float = 6.0
@export var stopping_distance: float = 0.5

# How often to check whether the cell is stuck.
@export var stuck_check_time: float = 2.0

# If it moved less than this distance, consider it stuck.
@export var stuck_distance_threshold: float = 0.1

# Small temporary push toward the player.
@export var force_movement_duration: float = 0.25
@export var force_movement_speed: float = 2.0


func _ready() -> void:
	parent_cell_container = get_parent().parent_cell_container

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


func _toggle(toggle_value: bool) -> void:
	walking_towards_player = toggle_value

	if walking_towards_player:
		player_reference = GLPlayerState.player_refrence

		last_checked_position = (
			parent_cell_container.global_position
		)

		stuck_check_timer.start()

	else:
		forcing_movement = false

		stuck_check_timer.stop()
		force_movement_timer.stop()

		parent_cell_container.velocity = Vector3.ZERO

		floor_nav_agent.target_position = (
			parent_cell_container.global_position
		)


func _physics_process(_delta: float) -> void:
	if not walking_towards_player:
		return

	if not is_instance_valid(parent_cell_container):
		return

	if not is_instance_valid(player_reference):
		player_reference = GLPlayerState.player_refrence

		if not is_instance_valid(player_reference):
			parent_cell_container.velocity = Vector3.ZERO
			return

	################################
	# SMALL PUSH WHEN STUCK        #
	################################

	if forcing_movement:
		parent_cell_container.velocity.x = (
			forced_direction.x * force_movement_speed
		)

		parent_cell_container.velocity.z = (
			forced_direction.z * force_movement_speed
		)

		parent_cell_container.move_and_slide()
		return

	############################
	# NORMAL NAVIGATION        #
	############################

	var distance_to_player: float = (
		parent_cell_container.global_position.distance_to(
			player_reference.global_position
		)
	)

	if distance_to_player <= stopping_distance:
		parent_cell_container.velocity.x = 0.0
		parent_cell_container.velocity.z = 0.0
		return

	var safe_target: Vector3 = (
		NavigationServer3D.map_get_closest_point(
			floor_nav_agent.get_navigation_map(),
			player_reference.global_position
		)
	)

	floor_nav_agent.target_position = safe_target

	if floor_nav_agent.is_navigation_finished():
		parent_cell_container.velocity.x = 0.0
		parent_cell_container.velocity.z = 0.0
		return

	var next_path_position: Vector3 = (
		floor_nav_agent.get_next_path_position()
	)

	var direction: Vector3 = (
		next_path_position
		- parent_cell_container.global_position
	)

	direction.y = 0.0

	if direction.is_zero_approx():
		parent_cell_container.velocity.x = 0.0
		parent_cell_container.velocity.z = 0.0
		return

	direction = direction.normalized()

	var look_position: Vector3 = next_path_position
	look_position.y = parent_cell_container.global_position.y

	if not parent_cell_container.global_position.is_equal_approx(
		look_position
	):
		parent_cell_container.look_at(
			look_position,
			Vector3.UP
		)

	parent_cell_container.velocity.x = (
		direction.x * walking_speed
	)

	parent_cell_container.velocity.z = (
		direction.z * walking_speed
	)

	parent_cell_container.move_and_slide()


func _handle_stuck_check_timer_timeout() -> void:
	if not walking_towards_player:
		return

	if forcing_movement:
		return

	if not is_instance_valid(parent_cell_container):
		return

	if not is_instance_valid(player_reference):
		return

	var current_position: Vector3 = (
		parent_cell_container.global_position
	)

	var distance_moved: float = (
		current_position.distance_to(
			last_checked_position
		)
	)

	last_checked_position = current_position

	if distance_moved > stuck_distance_threshold:
		return

	# Push directly toward the player.
	forced_direction = (
		player_reference.global_position
		- parent_cell_container.global_position
	)

	# Only force horizontal movement.
	forced_direction.y = 0.0

	if forced_direction.is_zero_approx():
		return

	forced_direction = forced_direction.normalized()

	forcing_movement = true

	force_movement_timer.wait_time = force_movement_duration
	force_movement_timer.start()


func _handle_force_movement_timer_timeout() -> void:
	forcing_movement = false

	parent_cell_container.velocity.x = 0.0
	parent_cell_container.velocity.z = 0.0

	last_checked_position = (
		parent_cell_container.global_position
	)


func _exit_tree() -> void:
	if is_instance_valid(parent_cell_container):
		parent_cell_container.velocity = Vector3.ZERO
