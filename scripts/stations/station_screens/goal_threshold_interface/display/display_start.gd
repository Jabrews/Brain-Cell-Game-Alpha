extends Node

# parent station component
@onready var parent_screen_interface : Node2D = $".."

# components
@onready var start_end_increment_timer  : Timer = $StartEndIncrement
@onready var start_overlay : Control = $"../StartOverlay"
@onready var start_label : Label = $"../StartOverlay/Label"

@export var start_end_wait_time : int = 10

var max_start_end_wait_timer : int

func _ready() -> void:
	max_start_end_wait_timer = start_end_wait_time
	
	start_end_increment_timer.connect('timeout', _handle_start_end_increment_timer_timeout)
	
func _display(toggle_value : bool) :
	if toggle_value : 
		start_end_increment_timer.start()
		start_overlay.visible = true
	else :
		start_end_increment_timer.stop()
		start_overlay.visible = false 

func _handle_start_end_increment_timer_timeout() :
	start_end_wait_time -= 1
	
	start_label.text = str(start_end_wait_time)
	
	if start_end_wait_time <= 0 :	
		parent_screen_interface._handle_start_delay_ended()
		_display(false)
		
	
