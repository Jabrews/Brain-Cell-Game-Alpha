extends Sprite2D

var bounce_tween : Tween
var org_pos : Vector2


func _ready() -> void:
	org_pos = global_position
	
func _toggle_skull(toggle_value : bool): 
	
	
	if bounce_tween : 		
		bounce_tween.kill()
	
	if toggle_value: 
		
		bounce_tween = create_tween()
		bounce_tween.set_loops()		
		bounce_tween.tween_property(self, 'position:y', org_pos.y + 5, 0.5)
		bounce_tween.tween_property(self, 'position:y', org_pos.y , 0.5)
		
		var scale_tween: Tween = create_tween()

		scale_tween.tween_property(
			self,
			"scale",
			Vector2(1.5, 1.5),
			0.15
		).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

		scale_tween.tween_property(
			self,
			"scale",
			Vector2(1.0, 1.0),
			0.15
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)		
		
		visible = true		
		
	else : 
		visible = false 
