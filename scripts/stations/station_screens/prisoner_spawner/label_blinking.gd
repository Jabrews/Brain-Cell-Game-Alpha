extends Label


var blink_tween : Tween 

func _display(toggle_value : bool) -> void:
	
	if toggle_value : 
		if blink_tween :
			blink_tween.kill()
			
		blink_tween = create_tween()	
		blink_tween.set_loops()
		
		blink_tween.tween_property(self, 'visible', true, 1.0)	
		blink_tween.tween_property(self, 'visible', false, 0.5)
	
	if not toggle_value : 
		if blink_tween :
			blink_tween.kill()
		visible = false
	
	
