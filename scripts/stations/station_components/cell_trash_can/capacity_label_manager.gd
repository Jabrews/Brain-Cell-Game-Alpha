extends Node

# components
@onready var curr_amount_label: Label3D = $CurrAmount
@onready var max_capacity_label: Label3D = $MaxCapacity

var flash_color_tween: Tween
var flash_shake_tween: Tween

var is_flashing: bool = false

var curr_amount_start_pos: Vector3
var max_capacity_start_pos: Vector3

var normal_color: Color = Color.WHITE
var full_color: Color = Color.RED


func _ready() -> void:
	curr_amount_start_pos = curr_amount_label.position
	max_capacity_start_pos = max_capacity_label.position
	
	normal_color = curr_amount_label.modulate


func _update_labels(curr_trash_filled: int, max_capacity: int) -> void:
	# update num labels
	curr_amount_label.text = str(curr_trash_filled)
	max_capacity_label.text = str(max_capacity)

	var at_capacity: bool = curr_trash_filled >= max_capacity

	if at_capacity != is_flashing:
		toggle_flash_labels(at_capacity)


func toggle_flash_labels(toggle_value: bool) -> void:
	is_flashing = toggle_value

	if flash_color_tween:
		flash_color_tween.kill()
		flash_color_tween = null

	if flash_shake_tween:
		flash_shake_tween.kill()
		flash_shake_tween = null

	# reset positions
	curr_amount_label.position = curr_amount_start_pos
	max_capacity_label.position = max_capacity_start_pos

	if toggle_value:
		_start_flash()
	else:
		curr_amount_label.modulate = normal_color
		max_capacity_label.modulate = normal_color


func _start_flash() -> void:
	flash_color_tween = create_tween()
	flash_color_tween.set_loops()
	
	flash_color_tween.tween_property(curr_amount_label, "modulate", full_color, 0.15)
	flash_color_tween.parallel().tween_property(max_capacity_label, "modulate", full_color, 0.15)
	
	flash_color_tween.tween_property(curr_amount_label, "modulate", normal_color, 0.15)
	flash_color_tween.parallel().tween_property(max_capacity_label, "modulate", normal_color, 0.15)

	flash_shake_tween = create_tween()
	flash_shake_tween.set_loops()

	var shake_amount: float = 0.03

	flash_shake_tween.tween_property(curr_amount_label, "position", curr_amount_start_pos + Vector3(shake_amount, 0, 0), 0.05)
	flash_shake_tween.parallel().tween_property(max_capacity_label, "position", max_capacity_start_pos + Vector3(shake_amount, 0, 0), 0.05)

	flash_shake_tween.tween_property(curr_amount_label, "position", curr_amount_start_pos - Vector3(shake_amount, 0, 0), 0.05)
	flash_shake_tween.parallel().tween_property(max_capacity_label, "position", max_capacity_start_pos - Vector3(shake_amount, 0, 0), 0.05)

	flash_shake_tween.tween_property(curr_amount_label, "position", curr_amount_start_pos, 0.05)
	flash_shake_tween.parallel().tween_property(max_capacity_label, "position", max_capacity_start_pos, 0.05)
