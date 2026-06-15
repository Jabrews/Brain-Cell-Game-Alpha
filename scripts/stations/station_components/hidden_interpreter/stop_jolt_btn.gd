extends InteractableBtn

func _on_btn_interacted():
	
	if get_parent().jolt_active :
		get_parent()._handle_stop_jolt_btn_pressed()
	
