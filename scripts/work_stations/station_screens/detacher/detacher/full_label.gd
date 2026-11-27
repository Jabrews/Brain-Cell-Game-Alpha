extends Label

@export var scale_multiplier: float = 1.1
@export var duration: float = 0.5


func _ready() -> void:
	# Scale from the center of the label.
	pivot_offset = size / 2.0

	var original_scale: Vector2 = scale

	var tween: Tween = create_tween().set_loops()

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(self, "scale", original_scale * scale_multiplier, duration)
	tween.tween_property(self, "scale", original_scale, duration)
