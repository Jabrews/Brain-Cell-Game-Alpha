extends Node

@onready var parent_defect_scraps_ui: Control = $".."

@export_range(0.0, 1.0, 0.05) var low_opacity: float = 0.35
@export_range(0.05, 5.0, 0.05) var fade_duration: float = 5.0

var opacity_tween: Tween


func _reset() -> void:
	if opacity_tween and opacity_tween.is_running():
		opacity_tween.kill()

	parent_defect_scraps_ui.modulate.a = 1.0
	

func _initate_fade() -> void:
	if opacity_tween and opacity_tween.is_running():
		opacity_tween.kill()

	parent_defect_scraps_ui.modulate.a = 1.0

	opacity_tween = create_tween()
	opacity_tween.set_loops()
	opacity_tween.set_trans(Tween.TRANS_SINE)
	opacity_tween.set_ease(Tween.EASE_IN_OUT)

	opacity_tween.tween_property(
		parent_defect_scraps_ui,
		"modulate:a",
		low_opacity,
		fade_duration
	)
	opacity_tween.tween_property(
		parent_defect_scraps_ui,
		"modulate:a",
		1.0,
		fade_duration
	)


func _stop() -> void:
	if opacity_tween and opacity_tween.is_running():
		opacity_tween.kill()

	parent_defect_scraps_ui.modulate.a = 1.0
