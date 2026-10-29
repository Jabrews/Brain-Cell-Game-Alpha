extends Control

@export var hover_height: float = 8.0
@export var hover_duration: float = 0.8
@export var flash_duration: float = 0.7
@export_range(0.0, 1.0) var lowest_alpha: float = 0.35

var _start_y: float
var _start_alpha: float


func _ready() -> void:
	_start_y = position.y
	_start_alpha = modulate.a

	var hover_tween := create_tween().set_loops()
	hover_tween.set_trans(Tween.TRANS_SINE)
	hover_tween.set_ease(Tween.EASE_IN_OUT)
	hover_tween.tween_property(
		self,
		"position:y",
		_start_y - hover_height,
		hover_duration
	)
	hover_tween.tween_property(
		self,
		"position:y",
		_start_y + hover_height,
		hover_duration
	)

	var flash_tween := create_tween().set_loops()
	flash_tween.tween_property(
		self,
		"modulate:a",
		_start_alpha * lowest_alpha,
		flash_duration * 0.5
	)
	flash_tween.tween_property(
		self,
		"modulate:a",
		_start_alpha,
		flash_duration * 0.5
	)
