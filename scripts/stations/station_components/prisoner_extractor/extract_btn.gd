extends InteractableBtn

# components
@onready var parent_prisoner_extractor : Node3D = $"../.."


func _on_btn_interacted():
	
	if parent_prisoner_extractor.innactive == true : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed') 
		return
	
	if len(parent_prisoner_extractor.cells_to_create) <= 0 : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed') 
		return
	else : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success') 
		parent_prisoner_extractor._handle_extract_btn_pressed()
	
