extends Node3D

@onready var screen_mutation_reciever_display : Node2D =$MutationMesh/SubViewport/MutationRecieverScreen
@onready var screen_stat_reciever_display : Node2D =$StatMesh/SubViewport/BasicRecieverScreen
@onready var mutation_mesh : MeshInstance3D = $MutationMesh

@export var yaw_offset: float = 0.0

var player : CharacterBody3D


func _handle_brain_cell_recieved(cell : BrainCell) -> void:
	screen_stat_reciever_display._handle_brain_cell_recieved(cell)
	
	if cell.mutation : 
		screen_mutation_reciever_display._handle_brain_cell_recieved(cell.mutation)
	else : 
		mutation_mesh.visible = false

func _process(_delta: float) -> void:
	if not visible:
		return
	
	if not player:
		return
		
	if visible and player : 
		_face_player_y_only()


func _face_player_y_only() -> void:
	var dir: Vector3 = player.global_position - global_position
	dir.y = 0.0

	if dir.length_squared() <= 0.001:
		return

	var target_yaw: float = atan2(dir.x, dir.z) + yaw_offset

	global_rotation.y = target_yaw

func set_player_reference(player_reference: CharacterBody3D) -> void:
	player = player_reference
