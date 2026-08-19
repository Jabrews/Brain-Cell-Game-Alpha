extends Node

@onready var light : OmniLight3D = $Light1
@onready var flash_timer : Timer = $FlashDelay
@onready var s_door_bleep : AudioStreamPlayer3D = $"../Audio/DoorBleep"

func _ready() -> void:
	flash_timer.connect('timeout', _handle_flash_timer_timeout)

func _start() :
	flash_timer.start()

func _stop() :
	flash_timer.stop()
	s_door_bleep.stop()
	light.light_energy = 0.0

func _handle_flash_timer_timeout() :
	
	if light.light_energy == 0.0 : 
		light.light_energy = 1.0
		s_door_bleep.play()
	else : 
		light.light_energy = 0.0
		
	
	

	
	
	
