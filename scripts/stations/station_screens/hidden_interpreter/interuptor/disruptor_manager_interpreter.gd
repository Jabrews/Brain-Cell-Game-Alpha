extends Node

@onready var hack_text_manager : Control = $HackTextManager
@onready var hack_skull_manager : Control = $HackSkullManager

func _ready() -> void:
	GLGameManagerBus.connect('process_next_round', _handle_process_next_round)

func _handle_process_next_round() :
	_display_interuption(false)

		
func _display_interuption(toggle_value : bool) : 
	if toggle_value : 
		hack_text_manager._start_hack_text()
		hack_skull_manager._start_hack_skull()
	else : 
		hack_text_manager._stop_hack_text()
		hack_skull_manager._stop_hack_skull()
	
	
