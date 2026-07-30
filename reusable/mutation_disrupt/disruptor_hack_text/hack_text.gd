extends Control 

@onready var switch_text_timer_delay : Timer = $SwitchTextTimerDelay
@onready var text_label : Label = $TextLabel



var possible_chars : Array[String]= [
	'1', '0', '?', '!', 'X', 
]
var opacity_tween : Tween


func _ready() -> void:
	switch_text_timer_delay.connect('timeout', _handle_switch_text_timer_delay_timeout)

func _start_display() : 
	switch_text_timer_delay.start()	
	
	if opacity_tween : 
		opacity_tween.kill()
	
	opacity_tween = create_tween()
	opacity_tween.tween_property(self, 'modulate:a', 1.0, 0.5)
	

func _end_display() :
	switch_text_timer_delay.stop()
	
	if opacity_tween : 
		opacity_tween.kill()
	
	opacity_tween = create_tween()
	opacity_tween.tween_property(self, 'modulate:a', 0.0, 0.5)
	
func _handle_switch_text_timer_delay_timeout() :
	text_label.text = possible_chars.pick_random()
	
	text_label.add_theme_color_override("font_color", Color.GREEN)
	
	var ran_num : int = randi_range(0, 100)	
	if ran_num < 50: 
		text_label.add_theme_color_override("font_color", Color.DARK_GREEN)	
	
	
	
	
