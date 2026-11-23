extends TextureRect

@export_range(0.0, 50.0, 0.5) var float_height: float = 5.0
@export_range(0.1, 5.0, 0.1) var float_duration: float = 0.4

var _rest_position: Vector2
var _float_tween: Tween


func _ready() -> void:
	_rest_position = position


func _toggle_float(toggle_value: bool) -> void:
	if toggle_value:
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
	else:
		if _float_tween and _float_tween.is_running():
			_float_tween.kill()

		position = _rest_position
