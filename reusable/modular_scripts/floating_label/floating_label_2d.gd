extends Label

@export var y_axis_positive_transform: float = 5.0
@export var float_speed: float = 0.5

var original_y_pos: float
var float_tween: Tween


func _ready() -> void:
	original_y_pos = position.y
	
	float_tween = create_tween()
	float_tween.set_loops()
	
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
