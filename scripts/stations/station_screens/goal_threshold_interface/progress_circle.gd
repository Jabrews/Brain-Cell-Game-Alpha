extends TextureRect

@onready var percant_label : Label = $PercantLabel
@onready var emergency_sprite : Sprite2D = $Emergency



func _update_percant_label(max_value : int, curr_value : int) -> void:
	var percent : int = roundi(
		(1.0 - (float(curr_value) / float(max_value))) * 100.0
	)
	
	percant_label.text = str(percent) + "%"
	
