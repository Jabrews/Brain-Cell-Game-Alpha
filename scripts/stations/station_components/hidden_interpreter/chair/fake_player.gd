extends Node

var look_target: Node3D
var forward_reference: Node3D

@export var horizontal_look_range_degrees: float = 45.0
@export var vertical_min_degrees: float = -30.0
@export var vertical_max_degrees: float = 40.0

@export var mouse_sensitivity_x: float = 0.003
@export var mouse_sensitivity_y: float = 0.003

# Use this only if your camera rig is visually offset.
# Try 0, 90, -90, or 180.
@export var yaw_offset_degrees: float = 0.0

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D

var current_yaw: float = 0.0


func _ready() -> void:
	var parent := get_parent()

	look_target = parent.camera_look_target
	forward_reference = parent.camera_foward_refrence

	await get_tree().process_frame

	current_yaw = _get_target_y_rotation_local() + deg_to_rad(yaw_offset_degrees)
	camera_pivot.rotation.y = current_yaw


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion:
		return

	if not look_target:
		return

	var center_y: float = _get_target_y_rotation_local() + deg_to_rad(yaw_offset_degrees)
	var look_range: float = deg_to_rad(horizontal_look_range_degrees)

	current_yaw -= event.relative.x * mouse_sensitivity_x

	var difference_from_center: float = angle_difference(center_y, current_yaw)
	difference_from_center = clamp(difference_from_center, -look_range, look_range)

	current_yaw = center_y + difference_from_center
	camera_pivot.rotation.y = current_yaw

	camera.rotate_x(-event.relative.y * mouse_sensitivity_y)
	camera.rotation.x = clamp(
		camera.rotation.x,
		deg_to_rad(vertical_min_degrees),
		deg_to_rad(vertical_max_degrees)
	)


func _get_target_y_rotation_local() -> float:
	var pivot_parent := camera_pivot.get_parent() as Node3D

	if not pivot_parent:
		return camera_pivot.rotation.y

	var local_pivot_pos: Vector3 = pivot_parent.to_local(camera_pivot.global_position)
	var local_target_pos: Vector3 = pivot_parent.to_local(look_target.global_position)

	var direction: Vector3 = local_target_pos - local_pivot_pos
	direction.y = 0.0

	if direction.length() == 0.0:
		return camera_pivot.rotation.y

	direction = direction.normalized()

	return atan2(-direction.x, -direction.z)
