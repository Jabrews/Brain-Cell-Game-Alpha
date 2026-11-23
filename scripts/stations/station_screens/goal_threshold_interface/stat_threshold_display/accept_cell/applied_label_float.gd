extends Label

@export_range(0.0, 100.0, 0.5) var hover_height: float = 6.0
@export_range(0.05, 10.0, 0.05) var movement_duration: float = 0.8
@export_range(0.1, 3.0, 0.01) var minimum_scale: float = 1.0
@export_range(0.1, 3.0, 0.01) var maximum_scale: float = 1.08

func _ready() -> void:
	pivot_offset = size * 0.5
	scale = Vector2.ONE * minimum_scale

	var starting_position: Vector2 = position
	var tween: Tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		self,
		"position",
		starting_position + Vector2.UP * hover_height,
		movement_duration
	)
	tween.parallel().tween_property(
		self,
		"scale",
		Vector2.ONE * maximum_scale,
		movement_duration
	)

	tween.tween_property(
		self,
		"position",
		starting_position,
		movement_duration
	)
	tween.parallel().tween_property(
		self,
		"scale",
		Vector2.ONE * minimum_scale,
		movement_duration
	)
