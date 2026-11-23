extends Control

@export_range(0.0, 1.0) var low_opacity: float = 0.3
@export_range(0.0, 1.0) var high_opacity: float = 1.0
@export var fade_duration: float = 0.5

var opacity_tween: Tween


func _ready() -> void:
	modulate.a = high_opacity

	opacity_tween = create_tween().set_loops()
	opacity_tween.set_trans(Tween.TRANS_SINE)
	opacity_tween.set_ease(Tween.EASE_IN_OUT)

	opacity_tween.tween_property(
		self, "modulate:a", low_opacity, fade_duration
	)
	opacity_tween.tween_property(
		self, "modulate:a", high_opacity, fade_duration
	)
