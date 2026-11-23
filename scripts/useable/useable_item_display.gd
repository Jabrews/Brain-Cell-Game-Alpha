extends Node3D

# componnets
@onready var tip_label : Label = $StatMesh/SubViewport/UseableItemScreen/ItemHint

var yaw_offset = -89.5
var show_distance = 2.0




func update_tip_label(text : String) :
	tip_label.text = text
	
func _process(_delta: float) -> void:
	if visible  : 
		_face_player_y_only()
		_auto_turn_off()
	

func _face_player_y_only() -> void:
	
	var player : CharacterBody3D = GLPlayerState.player_refrence	
	
	
	rotation = Vector3.ZERO
	
	var dir: Vector3 = player.global_position - global_position
	dir.y = 0.0

	if dir.length_squared() <= 0.001:
		return

	var target_yaw: float = atan2(dir.x, dir.z) + yaw_offset 

	global_rotation.y = target_yaw


func _auto_turn_off() -> void:
	var player: CharacterBody3D = GLPlayerState.player_refrence

	if player == null:
		return

	var distance_to_player: float = global_position.distance_to(
		player.global_position
	)

	visible = distance_to_player <= show_distance
