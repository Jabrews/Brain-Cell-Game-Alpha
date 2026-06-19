extends Sprite2D

func _load(starting_global_position : Vector2, starting_scale : Vector2) -> void:
	
	scale = starting_scale 
	
	scale -= Vector2(0.1, 0.1)	
	
	# set initial low opacity
	modulate.a = 0.3
	
	# set position
	global_position = starting_global_position
	
	# opacity to 0 tween
	var opacity_tween: Tween = create_tween()
	opacity_tween.tween_property(self, "modulate:a", 0.0, 1.5)
	
	# once finished delete
	await opacity_tween.finished
	queue_free()
