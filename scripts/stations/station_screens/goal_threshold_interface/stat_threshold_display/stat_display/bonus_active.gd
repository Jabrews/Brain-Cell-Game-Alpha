extends Control

@export_range(0.0, 100.0, 0.5) var float_height: float = 2.0
@export_range(0.05, 10.0, 0.05) var float_duration: float = 1.0

var _rest_position: Vector2
var _float_tween: Tween

func _ready() -> void:
	_rest_position = position



func _toggle_enabled(toggle_value: bool) -> void:
	visible = toggle_value

	if toggle_value:
		_start_floating()
	else:
		_stop_floating()


func _start_floating() -> void:
	if _float_tween and _float_tween.is_running():
		return

	_float_tween = create_tween()
	_float_tween.set_loops()
	_float_tween.set_trans(Tween.TRANS_SINE)
	_float_tween.set_ease(Tween.EASE_IN_OUT)

	_float_tween.tween_property(
		self,
		"position",
		_rest_position + Vector2.UP * float_height,
		float_duration
	)
	_float_tween.tween_property(
		self,
		"position",
		_rest_position,
		float_duration
	)


func _stop_floating() -> void:
	if _float_tween and _float_tween.is_running():
		_float_tween.kill()

	position = _rest_position
