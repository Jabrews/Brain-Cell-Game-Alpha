extends Control 

@onready var blocker_text : Label = $TextLabel
@onready var switch_text_delay_timer : Timer = $SwitchTextDelayTimer

var possible_chars : Array[String]= [
	'1', '0', '?', '!'
]

func _ready() -> void:
	switch_text_delay_timer.connect('timeout', _handle_switch_text_delay_timer_timeout)	

func _start_time_blocker()	:
	visible = true
	switch_text_delay_timer.start()

func _end_time_blocker(): 
	switch_text_delay_timer.stop()
	visible = false
	
func _handle_switch_text_delay_timer_timeout() :
	
	var ran_num_1 : int = randi_range(0, 100)	
	if ran_num_1 < 50: 
		visible = false
		return
	
	visible = true
	
	blocker_text.text = possible_chars.pick_random()	
	
	blocker_text.add_theme_color_override("font_color", Color.GREEN)
	
	var ran_num_2 : int = randi_range(0, 100)	
	if ran_num_2 < 50: 
		blocker_text.add_theme_color_override("font_color", Color.DARK_GREEN)
		
	
	
	
	
	
