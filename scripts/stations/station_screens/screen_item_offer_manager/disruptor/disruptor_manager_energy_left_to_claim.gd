extends Node

@onready var arrow_blocker : Control = $ArrowBlocker


func _ready() -> void:
	GLGameManagerBus.connect('process_next_round', _handle_process_next_round)

func _handle_process_next_round() :
	_display_interuption(false)

func _display_interuption(toggle_value : bool) : 
	if toggle_value : 
		arrow_blocker._start_arrow_blocker()
	else : 
		arrow_blocker._end_arrow_blocker()
	
	
