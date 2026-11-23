extends InteractableBtn

@onready var parent_door_button : Node3D = $".."


func _on_btn_interacted() :
	
	if parent_door_button.corrisponding_door.door_locked == true :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	if parent_door_button.corrisponding_door.door_open == true :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	else : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
		parent_door_button.corrisponding_door._open_door()
		return
