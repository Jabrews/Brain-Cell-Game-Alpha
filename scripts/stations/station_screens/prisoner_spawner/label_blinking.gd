extends Label



func _ready() -> void:
	
	
	var blink_tween = create_tween()	
	blink_tween.set_loops()
	
	blink_tween.tween_property(self, 'visible', true, 1.0)	
	blink_tween.tween_property(self, 'visible', false, 0.5)	
	
	
	
