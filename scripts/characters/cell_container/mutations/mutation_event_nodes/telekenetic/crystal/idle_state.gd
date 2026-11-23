extends Node

# componentns
@onready var parent_crystal_body : CharacterBody3D = $"../.."
@export var float_y_distance : float = 0.5


var float_tween : Tween
var rotate_tween : Tween
var org_pos : Vector3
var org_rotation  : Vector3


func state_start() -> void:
	
	parent_crystal_body.visible = false
	
	await get_tree().physics_frame
	
	parent_crystal_body.visible = true
	
	org_pos = parent_crystal_body.global_position
	
	org_rotation = parent_crystal_body.rotation	
	
	
	handle_float_vertical_tween()
	handle_rotate_tween()
	
	
func handle_float_vertical_tween(): 
	if float_tween : 	
		float_tween.kill()
	
	float_tween = create_tween()
	float_tween.set_loops()

	#float_tween.set_trans(Tween.TRANS_QUAD)
	#float_tween.set_ease(Tween.EASE_OUT)

	float_tween.tween_property(parent_crystal_body, "global_position:y", org_pos.y + float_y_distance, 1.0)
	float_tween.tween_property(parent_crystal_body, "global_position:y", org_pos.y, 0.5 )
	float_tween.tween_property(parent_crystal_body, "global_position:y", org_pos.y - float_y_distance, 1.0)

func handle_rotate_tween() -> void:
	if rotate_tween:
		rotate_tween.kill()

	parent_crystal_body.rotation.y = org_rotation.y

	rotate_tween = create_tween()
	rotate_tween.set_loops()
	#rotate_tween.set_trans(Tween.TRANS_LINEAR)

	rotate_tween.tween_property(
		parent_crystal_body,
		"rotation:y",
		org_rotation.y + TAU,
		5.0
	)


func state_process(_delta) -> void:
	pass


func state_end() -> void:
	parent_crystal_body.velocity = Vector3.ZERO
	float_tween.kill()
	rotate_tween.kill()
