extends InteractableBtn


func _on_btn_interacted() : 
	get_parent()._on_breed_confirm_btn_down()
