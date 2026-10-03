extends Control



func _ready() -> void:
	
	var orginal_pos : Vector2 = position
	
	
	var float_tween : Tween = create_tween()
	
	float_tween.set_loops()
	
	float_tween.tween_property(self, 'position:y', orginal_pos.y + 5.0, 0.5)
	float_tween.tween_property(self, 'position:y', orginal_pos.y, 0.5)
	float_tween.tween_property(self, 'position:y', orginal_pos.y -  5.0, 0.5)
	
	
	
