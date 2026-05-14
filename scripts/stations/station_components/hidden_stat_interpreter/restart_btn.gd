extends InteractableBtn 


func _on_btn_interacted():
	get_parent()._handle_reset_btn()
	
