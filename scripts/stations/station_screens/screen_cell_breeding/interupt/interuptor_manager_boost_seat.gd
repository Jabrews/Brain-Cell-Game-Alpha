extends Node

@onready var hack_text_manager : Control = $HackTextManager

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') : 
		_display_interuption(true)
	elif Input.is_action_just_pressed('debug2') : 
		_display_interuption(false)
		
func _display_interuption(toggle_value : bool) : 
	if toggle_value : 
		hack_text_manager._start_hack_text()
	else : 
		hack_text_manager._stop_hack_text()
	
	
