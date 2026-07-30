extends Node

@onready var arrow_blockers : Array[Control] = [
	$ArrowBlockers/ArrowBlocker,
	$ArrowBlockers/ArrowBlocker2,
	$ArrowBlockers/ArrowBlocker3	
]
@onready var hack_text_manager : Control = $HackTextManager
@onready var hack_skull_manager : Control = $HackSkullManager

func _ready() -> void:
	GLGameManagerBus.connect('process_next_round', _handle_process_next_round)

func _handle_process_next_round() :
	_display_interuption(false)


func _display_interuption(toggle_value : bool) : 
	if toggle_value : 
		hack_text_manager._start_hack_text()
		for arrow_blocker : Control in arrow_blockers : 
			arrow_blocker._start_arrow_blocker()
		hack_skull_manager._start_hack_skull()
	else : 
		hack_text_manager._stop_hack_text()
		for arrow_blocker : Control in arrow_blockers : 
			arrow_blocker._end_arrow_blocker()
		hack_skull_manager._stop_hack_skull()
	
	
