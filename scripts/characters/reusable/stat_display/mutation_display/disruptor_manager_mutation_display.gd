extends Node

@onready var hack_text_manager : Control = $HackTextManager

var displaying_interuption : bool = false

func _ready() -> void:
	GLGameManagerBus.connect('process_next_round', _handle_process_next_round)

func _handle_process_next_round() :
	_display_interuption(false)

func _display_interuption(toggle_value : bool) : 
	if toggle_value : 
		hack_text_manager._start_hack_text()
	else : 
		hack_text_manager._stop_hack_text()
