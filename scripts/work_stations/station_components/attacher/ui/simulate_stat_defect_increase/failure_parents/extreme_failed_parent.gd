extends Control

# float settings
@export var y_axis_positive_transform: float = 5.0
@export var float_speed: float = 0.5

# scale settings
@export var scale_amount: float = 0.05
@export var scale_speed: float = 0.5

var original_y_pos: float
var original_scale: Vector2

var float_tween: Tween
var scale_tween: Tween


func _ready() -> void:
	original_y_pos = position.y
	original_scale = scale

	# scale from center
	pivot_offset = size / 2.0
	resized.connect(_update_pivot)

	_start_floating()
	_start_scaling()


func _start_floating() -> void:
	float_tween = create_tween()
	float_tween.set_loops()
	float_tween.set_trans(Tween.TRANS_SINE)
	float_tween.set_ease(Tween.EASE_IN_OUT)

	float_tween.tween_property(
		self,
		"position:y",
		original_y_pos + y_axis_positive_transform,
		float_speed
	)

	float_tween.tween_property(
		self,
		"position:y",
		original_y_pos,
		float_speed
	)

	float_tween.tween_property(
		self,
		"position:y",
		original_y_pos - y_axis_positive_transform,
		float_speed
	)

	float_tween.tween_property(
		self,
		"position:y",
		original_y_pos,
		float_speed
	)


func _start_scaling() -> void:
	scale_tween = create_tween()
	scale_tween.set_loops()

	scale_tween.tween_property(
		self,
		"scale",
		original_scale * (1.0 + scale_amount),
		scale_speed
	)

	scale_tween.tween_property(
		self,
		"scale",
		original_scale,
		scale_speed
	)

	scale_tween.tween_property(
		self,
		"scale",
		original_scale * (1.0 - scale_amount),
		scale_speed
	)

	scale_tween.tween_property(
		self,
		"scale",
		original_scale,
		scale_speed
	)


func _update_pivot() -> void:
	pivot_offset = size / 2.0
