extends Control 

@export var active_room_name : String

# component timer
@onready var flash_delay_timer : Timer = $FlashDelayTimer


func _ready() -> void:
	GLMutationDisruptState.connect('disrupt_incoming', _handle_disrupt_incoming)
	GLMutationDisruptState.connect('disrupt_ended', _handle_disrupt_ended)
	flash_delay_timer.connect('timeout', _handle_flash_delay_timer_timeout)
	
func _handle_disrupt_incoming(room_name : String) :
	if active_room_name == room_name : 
		if flash_delay_timer.is_stopped() : 
			flash_delay_timer.start()
			visible = true
		
	else :
		flash_delay_timer.stop()
		visible = false 

func _handle_disrupt_ended() :
	flash_delay_timer.stop()
	visible = false 

func _handle_flash_delay_timer_timeout() :
	visible = !visible
