extends Node


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') :	
		var control := get_viewport().gui_get_hovered_control()

		if control:
			print("Blocking/hovered Control: ", control.get_path())
			print("Mouse Filter: ", control.mouse_filter)
		else:
			print("No Control detected")
		pass
			
	if Input.is_action_just_pressed('debug2') :	
		pass
