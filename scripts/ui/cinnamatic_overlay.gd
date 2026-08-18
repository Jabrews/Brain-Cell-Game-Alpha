extends Sprite2D

func _ready() -> void:
	GLCinnamaticBus.connect('toggle_energy_cinnamatic', _handle_toggle_energy_cinnamatic)


func _handle_toggle_energy_cinnamatic(toggle_value : bool) : 
	
	modulate.a = 0.0
	
	if not toggle_value : 
		visible = false
	else : 
		visible = true
		var opacity_tween : Tween = create_tween()
		opacity_tween.tween_property(self, 'modulate:a', 1.0, 1.0)
	
