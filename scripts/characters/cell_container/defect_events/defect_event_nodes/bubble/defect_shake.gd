extends Node

var shake_tween: Tween

var base_scale: Vector3

@export var scale_amount: Vector3 = Vector3(0.15, 0.15, 0.15)
@export var scale_speed: float = 0.12

@export var shake_amount: Vector3 = Vector3(0.03, 0.03, 0.03)
@export var shake_speed: float = 0.05


func _ready() -> void:
	
	var parent_cell_container: CharacterBody3D = get_parent().parent_brain_cell_container
	
	base_scale = parent_cell_container.scale


func _toggle_shake(toggle_value: bool) -> void:
	var parent_cell_container: CharacterBody3D = get_parent().parent_brain_cell_container
	
	# Stop existing tweens
	if shake_tween:
		shake_tween.kill()
	
	# Disable
	if not toggle_value:
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
	
