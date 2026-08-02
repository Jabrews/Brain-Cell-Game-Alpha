extends MutationNode


@export var rotation_speed: float = 8.0
@export var horizontal_fly_speed: float = 1.5
@export var upward_fly_speed: float = 1.5

# componnets
@onready var raycast_manager: Node3D = $RaycastManager
@onready var fly_duration_timer: Timer = $FlyDurationTimer
@onready var start_flap_sound : AudioStreamPlayer3D = $StartFlap
@onready var wings_flapping_sound : AudioStreamPlayer3D = $WingsFlappingSound



var flight_active: bool = false
var flight_direction: Vector3 = Vector3.ZERO

var original_cell_basis: Basis
var target_flight_y: float = 0.



func _ready_overide() -> void:
	
	stop_on_pickup = true
	random_event = true
	
	original_cell_basis = parent_cell_container.global_basis
	
	fly_duration_timer.timeout.connect(
		_handle_fly_duration_timer_timeout
	)



func _physics_process(delta: float) -> void:
	if not flight_active:
		return

	var horizontal_direction: Vector3 = flight_direction
	horizontal_direction.y = 0.0
	horizontal_direction = horizontal_direction.normalized()

	parent_cell_container.velocity = Vector3(
		horizontal_direction.x * horizontal_fly_speed,
		upward_fly_speed,
		horizontal_direction.z * horizontal_fly_speed
	)

	parent_cell_container.move_and_slide()

	rotate_towards_flight_direction(
		parent_cell_container.velocity.normalized(),
		delta
	)


func _start() -> void:
	
	reveal_mutation()
	
	raycast_manager.switch_raycast_state("none")
	
	start_flap_sound.play()
	
	await get_tree().create_timer(0.5).timeout

	var target_ceiling_fan_placement: CeilingFanPlacement = null

	var cell_container_name: String = (
		parent_cell_container.designated_brain_cell.name
	)

	var entity_room_profiles: Array[EntityRoomProfile] = (
		GLEntityRoomManagementBus.entity_room_profiles
	)

	var cell_container_room: String = ""

	# Find the cell container's room.
	for profile: EntityRoomProfile in entity_room_profiles:
		if (
			profile.entity_type == "cell_container"
			and profile.entity_name == cell_container_name
		):
			cell_container_room = profile.room_name
			break

	if cell_container_room.is_empty():
		push_error(
			"No corresponding room profile found for cell: ",
			cell_container_name
		)
		return

	# Find a ceiling fan in the same room.
	var ceiling_fan_placements: Array[CeilingFanPlacement] = (
		GLCeilingFanPlacementsState.ceiling_fan_placements
	)

	var closest_distance: float = INF

	for ceiling_fan_placement: CeilingFanPlacement in ceiling_fan_placements:
		if ceiling_fan_placement.room != cell_container_room:
			continue

		var fan_position: Vector3 = (
			ceiling_fan_placement.coords
		)

		var distance_to_fan: float = (
			parent_cell_container.global_position.distance_squared_to(
				fan_position
			)
		)

		if distance_to_fan < closest_distance:
			closest_distance = distance_to_fan
			target_ceiling_fan_placement = ceiling_fan_placement

	#################
	# FAN FLIGHT    #
	#################

	if target_ceiling_fan_placement:
		move_towards_ceiling_fan(
			target_ceiling_fan_placement
		)

	#################
	# DEFAULT FLIGHT#
	#################

	else:
		var non_colliding_direction: Vector3 = (
			await search_for_non_colliding_direction()
		)

		start_flying_in_direction(
			non_colliding_direction
		)

	# Start duration timer for either flight mode.
	fly_duration_timer.start()

	# Activate obstacle-detection raycasts after a short delay.
	raycast_manager.switch_raycast_state("fly")
	
	wings_flapping_sound.play()


func move_towards_ceiling_fan(
	target_ceiling_fan_placement: CeilingFanPlacement
) -> void:
	
	await get_tree().create_timer(0.5).timeout
	
	var fan_global_coords: Vector3 =  target_ceiling_fan_placement.coords

	var direction_to_fan: Vector3 = (
		fan_global_coords
		- parent_cell_container.global_position
	)

	# Ignore vertical difference and fly horizontally.
	direction_to_fan.y = 0.0

	start_flying_in_direction(
		direction_to_fan
	)


func start_flying_in_direction(direction: Vector3) -> void:
	direction.y = 0.0

	if direction.is_zero_approx():
		handle_flight_interrupted()
		return

	flight_direction = direction.normalized()
	flight_active = true


func search_for_non_colliding_direction() -> Vector3:
	raycast_manager.switch_raycast_state("search")

	# Allow the RayCast3D nodes to update.
	await get_tree().create_timer(1.0).timeout

	var raycasts_detecting_collision: Dictionary = (
		raycast_manager.raycasts_detecting_collision
	)

	var open_direction_keys: Array[String] = []

	for raycast_key: String in raycasts_detecting_collision:
		var detecting_collision: bool = (
			raycasts_detecting_collision[raycast_key]
		)

		if not detecting_collision:
			open_direction_keys.append(raycast_key)

	# If every direction is blocked, select any direction.
	if open_direction_keys.is_empty():
		open_direction_keys = [
			"+x",
			"-x",
			"+z",
			"-z",
		]

	var selected_direction_key: String = (
		open_direction_keys.pick_random()
	)

	return raycast_manager.raycast_key_to_direction(
		selected_direction_key
	)



func rotate_towards_flight_direction(
	direction: Vector3,
	delta: float
) -> void:
	
	var target_basis: Basis = Basis.looking_at(
		direction,
		Vector3.UP
	)

	var rotation_weight: float = clamp(
		rotation_speed * delta,
		0.0,
		1.0
	)
	
	
	var current_basis: Basis = parent_cell_container.global_basis

	if not current_basis.is_equal_approx(
		current_basis.orthonormalized()
	):
		return

	parent_cell_container.global_basis = (
		parent_cell_container.global_basis.slerp(
			target_basis,
			rotation_weight
		)
	)


func _handle_fly_duration_timer_timeout() -> void:
	handle_flight_interrupted()


func handle_flight_interrupted() -> void:
	if not flight_active:
		return

	flight_active = false
	parent_cell_container.velocity = Vector3.ZERO

	# The mutation manager will remove this event and call _stop().
	random_event_finished()


func _stop() -> void:
	flight_active = false
	flight_direction = Vector3.ZERO

	fly_duration_timer.stop()
	raycast_manager.switch_raycast_state("none")

	parent_cell_container.velocity = Vector3.ZERO

	return_cell_upright()



func return_cell_upright() -> void:
	# Instantly restore the exact original rotation.
	parent_cell_container.global_basis = original_cell_basis
	
	# Remove any remaining movement.
	parent_cell_container.velocity = Vector3.ZERO
