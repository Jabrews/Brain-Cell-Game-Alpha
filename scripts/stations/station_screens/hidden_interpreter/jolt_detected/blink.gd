extends Control 


@onready var blink_interval_timer : Timer = $BlinkTimer


func _ready() -> void:
	blink_interval_timer.connect('timeout', _handle_blink_interval_timer_timeout)


func _toggle(toggle_value) : 
	visible = true
	
	if toggle_value : 
		blink_interval_timer.start()
	else : 
		blink_interval_timer.stop()	

func _handle_blink_interval_timer_timeout() :
	visible = !visible
	
