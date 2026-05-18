extends Sprite2D 

var active_tween : Tween
var base_rotation : float = -90.0


func _ready() -> void:
	rotation_degrees = base_rotation


func _set_breeding_arrow_phase(phase : int) :
	
	if active_tween:
		active_tween.kill()
	
	rotation_degrees = base_rotation
	scale = Vector2.ONE
	
	match phase:
		
		# 1 : nothing
		1:
			pass
		
		# 2 : very slight left/right rotation
		2:
			active_tween = create_tween()
			active_tween.set_loops()
			
			active_tween.tween_property(self, "rotation_degrees", base_rotation + 5, 0.4)
			active_tween.tween_property(self, "rotation_degrees", base_rotation - 5, 0.4)
		
		# 3 : stronger rotation + scale
		3:
			active_tween = create_tween()
			active_tween.set_loops()
			
			active_tween.tween_property(self, "rotation_degrees", base_rotation + 8, 0.3)
			active_tween.parallel().tween_property(self, "scale", Vector2(1, 1), 0.3)
			
			active_tween.tween_property(self, "rotation_degrees", base_rotation - 8, 0.3)
			active_tween.parallel().tween_property(self, "scale", Vector2(1.5,1.5), 0.3)
