extends Node

@onready var arrow_blockers : Array[Control] = [
	$ArrowBlockers/ArrowBlocker,
	$ArrowBlockers/ArrowBlocker2,
	$ArrowBlockers/ArrowBlocker3	
]
@onready var hack_text_manager : Control = $HackTextManager

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') : 
		_display_interuption(true)
	elif Input.is_action_just_pressed('debug2') : 
		_display_interuption(false)

func _display_interuption(toggle_value : bool) : 
	if toggle_value : 
		hack_text_manager._start_hack_text()
		for arrow_blocker : Control in arrow_blockers : 
			arrow_blocker._start_arrow_blocker()
	else : 
		hack_text_manager._stop_hack_text()
		for arrow_blocker : Control in arrow_blockers : 
			arrow_blocker._end_arrow_blocker()
	
	
