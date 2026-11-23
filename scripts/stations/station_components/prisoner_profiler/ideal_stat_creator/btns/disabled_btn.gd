extends InteractableBtn

## DISABLED BTN


func _on_btn_interacted():
	GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
	return
