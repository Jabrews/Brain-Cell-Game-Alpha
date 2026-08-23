extends Node

var shake_tween: Tween
var jolt_movement_tween: Tween

var base_positon: Vector3
var base_scale: Vector3

@export var scale_amount: Vector3 = Vector3(0.15, 0.15, 0.15)
@export var scale_speed: float = 0.12

@export var shake_amount: Vector3 = Vector3(0.03, 0.03, 0.03)
@export var shake_speed: float = 0.05


func _ready() -> void:
	var parent_cell_container: CharacterBody3D = get_parent().parent_brain_cell_container
	
	base_positon = parent_cell_container.global_position
	base_scale = parent_cell_container.scale


func _toggle_shake(toggle_value: bool) -> void:
	var parent_cell_container: CharacterBody3D = get_parent().parent_brain_cell_container
	
	# Stop existing tweens
	if shake_tween:
		shake_tween.kill()
	
	if jolt_movement_tween:
		jolt_movement_tween.kill()
	
	
	# Disable
	if not toggle_value:
		parent_cell_container.global_position = base_positon
		parent_cell_container.scale = base_scale
		return
	
	
	# Scale animation
	shake_tween = create_tween()
	shake_tween.set_loops()
	
	shake_tween.tween_property(
		parent_cell_container,
		"scale",
		base_scale + scale_amount,
		scale_speed
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	shake_tween.tween_property(
		parent_cell_container,
		"scale",
		base_scale,
		scale_speed
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	
	# Movement / shaking animation
	jolt_movement_tween = create_tween()
	jolt_movement_tween.set_loops()
	
	jolt_movement_tween.tween_property(
		parent_cell_container,
		"global_position",
		base_positon + Vector3(
			randf_range(-shake_amount.x, shake_amount.x),
			randf_range(-shake_amount.y, shake_amount.y),
			randf_range(-shake_amount.z, shake_amount.z)
		),
		shake_speed
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	jolt_movement_tween.tween_property(
		parent_cell_container,
		"global_position",
		base_positon,
		shake_speed
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
