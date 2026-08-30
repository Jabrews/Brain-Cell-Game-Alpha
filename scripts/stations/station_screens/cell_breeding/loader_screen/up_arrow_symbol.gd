extends Sprite2D

@export var float_distance: float = 2.0
@export var float_duration: float = 0.5

func _ready() -> void:
	var start_position := position
	
	var tween := create_tween()
	tween.set_loops()
	
	tween.tween_property(
		self,
		"position:y",
		start_position.y - float_distance,
		float_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(
		self,
		"position:y",
		start_position.y,
		float_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
