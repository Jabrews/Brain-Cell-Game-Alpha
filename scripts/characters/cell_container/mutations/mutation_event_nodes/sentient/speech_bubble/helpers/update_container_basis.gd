extends Node

@onready var bubble_panel_container: PanelContainer = \
	$"../SpeechBubbleTV/SubViewport/ScreenTextSpeechBubble/VBoxContainer/PanelContainer"

@onready var sub_viewport: SubViewport = \
	$"../SpeechBubbleTV/SubViewport"

@onready var mesh_instance: MeshInstance3D = \
	$"../SpeechBubbleTV"

@export var pixels_to_world_scale: float = 0.005
@export var extra_bottom_height: int = 20

var original_mesh_position: Vector3
var starting_bubble_world_height: float = 0.0


func _ready() -> void:
	original_mesh_position = mesh_instance.position

	# Each bubble needs its own mesh resource because its size changes.
	if mesh_instance.mesh:
		mesh_instance.mesh = mesh_instance.mesh.duplicate()


func _update() -> void:
	_update_container_sizing()
	_update_screen_height()


func _set_starting_height() -> void:
	_update_container_sizing()
	starting_bubble_world_height = _get_current_bubble_world_height()


func _reset() -> void:
	mesh_instance.position = original_mesh_position
	starting_bubble_world_height = 0.0


func _update_container_sizing() -> void:
	var panel_size: Vector2 = bubble_panel_container.size

	var viewport_size := Vector2i(
		maxi(1, ceili(panel_size.x)),
		maxi(1, ceili(panel_size.y) + extra_bottom_height)
	)

	sub_viewport.size = viewport_size

	var quad_mesh := mesh_instance.mesh as QuadMesh

	if quad_mesh == null:
		push_error("SpeechBubbleTV must use a QuadMesh.")
		return

	quad_mesh.size = Vector2(viewport_size) * pixels_to_world_scale


func _update_screen_height() -> void:
	if starting_bubble_world_height <= 0.0:
		return

	var current_world_height: float = _get_current_bubble_world_height()

	var added_world_height: float = maxf(
		0.0,
		current_world_height - starting_bubble_world_height
	)

	# Keep the bottom of the QuadMesh anchored while it grows upward.
	mesh_instance.position = original_mesh_position + Vector3(
		0.0,
		added_world_height * 0.5,
		0.0
	)


func _get_current_bubble_world_height() -> float:
	var quad_mesh := mesh_instance.mesh as QuadMesh

	if quad_mesh == null:
		return 0.0

	return quad_mesh.size.y
