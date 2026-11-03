extends Node

@onready var parent_cell_container: CharacterBody3D = $".."

@export var scale_multiplier: float = 1.25
@export var scale_up_duration: float = 0.12
@export var scale_down_duration: float = 0.12
@export var repeat_count: int = 2

var original_scale: Vector3
var scale_tween: Tween


func _ready() -> void:
	original_scale = parent_cell_container.scale
	GLCellManagerBus.connect("scale_cell", _handel_scale_cell)


func _handel_scale_cell(cell_name: String) -> void:
	var designated_brain_cell: BrainCell = parent_cell_container.designated_brain_cell

	if designated_brain_cell == null or designated_brain_cell.name != cell_name:
		return

	if scale_tween:
		scale_tween.kill()

	parent_cell_container.scale = original_scale

	scale_tween = create_tween()
	scale_tween.set_trans(Tween.TRANS_SINE)
	scale_tween.set_ease(Tween.EASE_IN_OUT)

	for i in range(repeat_count):
		scale_tween.tween_property(
			parent_cell_container,
			"scale",
			original_scale * scale_multiplier,
			scale_up_duration
		)
		scale_tween.tween_property(
			parent_cell_container,
			"scale",
			original_scale,
			scale_down_duration
		)
