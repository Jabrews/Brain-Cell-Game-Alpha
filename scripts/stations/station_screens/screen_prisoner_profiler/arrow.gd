extends Sprite2D

@export var arrow_type: String

const UP_ARROW: Texture2D = preload("res://models/screens/prisoner_profiler_symbols/arrow_up.png")
const DOWN_ARROW: Texture2D = preload("res://models/screens/prisoner_profiler_symbols/arrow_down.png")

var starting_position: Vector2
var float_tween: Tween


func _ready() -> void:
	
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST	
	
	starting_position = position
	
	match arrow_type:
		"up":
			texture = UP_ARROW
		"down":
			texture = DOWN_ARROW
		_:
			push_error("Invalid arrow_type: " + arrow_type)
			return
	
	float_tween = create_tween()
	float_tween.set_loops()
	
	float_tween.tween_property(
		self,
		"position:y",
		starting_position.y + 5.0,
		0.5
	)
	
	float_tween.tween_property(
		self,
		"position:y",
		starting_position.y,
		0.5
	)
	
	float_tween.tween_property(
		self,
		"position:y",
		starting_position.y - 5.0,
		0.5
	)
	
	float_tween.tween_property(
		self,
		"position:y",
		starting_position.y,
		0.5
	)
