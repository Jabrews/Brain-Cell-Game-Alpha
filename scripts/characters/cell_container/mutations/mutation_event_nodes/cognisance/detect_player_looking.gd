extends Node


# Components
@onready var parent_cognisance_mutation_node: Node3D = $".."
@onready var move_towards_player: Node = $"../MoveTowardsPlayer"


var walking_towards_player: bool = false

var parent_cell_container: CharacterBody3D
var player_reference: CharacterBody3D
var player_camera: Camera3D

var player_already_saw_cognisance: bool = false


@export var player_look_threshold: float = 0.92


func _ready() -> void:
	parent_cell_container = get_parent().parent_cell_container


func _toggle(toggle_value: bool) -> void:
	walking_towards_player = toggle_value

	if walking_towards_player:
		player_reference = GLPlayerState.player_refrence

		if is_instance_valid(player_reference):
			player_camera = player_reference.camera

		player_already_saw_cognisance = false

	else:
		player_already_saw_cognisance = false


func _physics_process(_delta: float) -> void:
	if not walking_towards_player:
		return

	if player_already_saw_cognisance:
		return

	if not is_instance_valid(player_reference):
		player_reference = GLPlayerState.player_refrence

		if not is_instance_valid(player_reference):
			return

		player_camera = player_reference.camera

	if not is_instance_valid(player_camera):
		player_camera = player_reference.camera

		if not is_instance_valid(player_camera):
			return

	if not verify_player_in_same_room_as_cell():
		return

	################################
	# CHECK IF CAMERA FACES CELL   #
	################################

	var direction_to_cell: Vector3 = (
		parent_cell_container.global_position
		- player_camera.global_position
	).normalized()

	# Camera's forward direction in Godot is -Z.
	var camera_forward: Vector3 = (
		-player_camera.global_transform.basis.z
	).normalized()

	var look_amount: float = camera_forward.dot(
		direction_to_cell
	)

	if look_amount >= player_look_threshold:
		player_saw_cognisance()


# Must be in the same room for it to be stopped.
func verify_player_in_same_room_as_cell() -> bool:
	var room_profiles: Array[EntityRoomProfile] = (
		GLEntityRoomManagementBus.entity_room_profiles
	)

	var cell_name: String = (
		parent_cell_container.designated_brain_cell.name
	)

	var cell_room: String = ""
	var player_room: String = ""

	for room_profile: EntityRoomProfile in room_profiles:
		if room_profile.entity_type == "player":
			player_room = room_profile.room_name

		elif room_profile.entity_type == "cell_container":
			if room_profile.entity_name == cell_name:
				cell_room = room_profile.room_name

	if cell_room.is_empty() or player_room.is_empty():
		push_error(
			"Trouble finding room for cell or player: %s, %s"
			% [
				cell_room,
				player_room
			]
		)

		return false

	return cell_room == player_room


func player_saw_cognisance() -> void:
	if not walking_towards_player:
		return

	player_already_saw_cognisance = true

	parent_cognisance_mutation_node._handle_cell_looked_at()
