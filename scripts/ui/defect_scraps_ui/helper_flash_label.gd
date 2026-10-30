extends Node

@onready var scraps_label: Label = $"../ScrapsLabel"

@export var increase_color: Color = Color.GREEN
@export var decrease_color: Color = Color.RED

const SCALE_UP_DURATION: float = 0.09
const SCALE_DOWN_DURATION: float = 0.09

var scale_tween: Tween
var down_scale: Vector2 = Vector2.ONE
var up_scale: Vector2 = Vector2(1.2, 1.2)


func _handle(direction: int) -> void:
	if direction == 0:
		return

	var flash_color: Color = increase_color if direction > 0 else decrease_color
	scraps_label.add_theme_color_override("font_color", flash_color)
	_initiate_scale_tween()


func _stop() -> void:
	if scale_tween and scale_tween.is_running():
		scale_tween.kill()

	_reset_visuals()


func _initiate_scale_tween() -> void:
	if scale_tween and scale_tween.is_running():
		scale_tween.kill()

	scale_tween = create_tween()
	scale_tween.tween_property(
		scraps_label,
		"scale",
		up_scale,
		SCALE_UP_DURATION
	)
	scale_tween.tween_property(
		scraps_label,
		"scale",
		down_scale,
		SCALE_DOWN_DURATION
	)
	scale_tween.tween_callback(_reset_visuals)


func _reset_visuals() -> void:
	scraps_label.scale = down_scale
	scraps_label.remove_theme_color_override("font_color")
