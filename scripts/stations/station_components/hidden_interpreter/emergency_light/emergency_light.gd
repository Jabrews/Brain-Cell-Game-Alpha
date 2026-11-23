extends Node

# components
@onready var flash_delay_timer : Timer = $FlashDelay
@onready var light : OmniLight3D = $Light1

var saved_interpreters_to_jolt : Array


func _ready() -> void:
	GLDefectEventMangerBus.connect('event_hidden_stat_interpreter_jolt', _handle_event_hidden_stat_interpreter_jolt)
	GLDefectEventMangerBus.connect('stopped_jolt', _handle_stopped_jolt)
	
	
	flash_delay_timer.connect('timeout', _handle_flash_delay_timer_timeout)	
	
	_toggle_lights(false)


func _handle_event_hidden_stat_interpreter_jolt(interpreters_to_jolt : Array) :
	saved_interpreters_to_jolt = interpreters_to_jolt
	_toggle_lights(true)


func _handle_stopped_jolt(interpreter_type : String) :
	
	saved_interpreters_to_jolt.erase(interpreter_type)	
	
	if len(saved_interpreters_to_jolt) == 0 :
		_toggle_lights(false)


func _handle_flash_delay_timer_timeout() :
	if light.light_energy == 1.0 :
		light.light_energy = 0.0 
	else :
		light.light_energy = 1.0 


func _toggle_lights(toggle_value : bool) :
	if toggle_value : 
		flash_delay_timer.start()
		light.light_energy = 1.0	
	else : 
		flash_delay_timer.stop()
		light.light_energy = 0.0	
		
		
