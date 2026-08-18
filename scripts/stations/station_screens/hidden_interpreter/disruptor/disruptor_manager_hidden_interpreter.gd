extends Node


@onready var hack_text_manager : Control = $HackTextManager
# progress blocker
@onready var time_blockers : Array[Control] = [
	$ProgressBlocker/TimeBlockers/TimeBlocker, $ProgressBlocker/TimeBlockers/TimeBlocker2, $ProgressBlocker/TimeBlockers/TimeBlocker3, $ProgressBlocker/TimeBlockers/TimeBlocker4, $ProgressBlocker/TimeBlockers/TimeBlocker5
]
@onready var bar_blocker : AnimatedSprite2D = $ProgressBlocker/BarBlocker

var displaying_interuption : bool = false


func _ready() -> void:
	GLGameManagerBus.connect('process_next_round', _handle_process_next_round)

func _handle_process_next_round() :
	_display_interuption(false)
		
func _display_interuption(toggle_value : bool) : 
	displaying_interuption = toggle_value
	if toggle_value : 
		hack_text_manager._start_hack_text()
		
		# time blocker
		for time_blocker : Control in time_blockers : 	
			time_blocker._start_time_blocker()
		bar_blocker.visible = true
		
	else : 
		hack_text_manager._stop_hack_text()
	
		# time blocker
		for time_blocker : Control in time_blockers : 	
			time_blocker._end_time_blocker()
		bar_blocker.visible = false 
	
	
