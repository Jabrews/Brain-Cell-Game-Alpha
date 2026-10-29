extends Node

@onready var invalid_energy_left_parent : Control = $"../FeedbackInvalidEnergyLeft"

@onready var feedback_display_parent : Control = $"../FeedbackDisplay"
@onready var feedback_bg : ColorRect = $"../FeedbackDisplay/FeedbackBG"
@onready var feedback_label : Label = $"../FeedbackDisplay/FeedbackLabel"
@onready var fade_delay_timer : Timer = $FadeDelayTimer

func _ready() -> void:
	GLPrisonerProfilerComponentsBus.connect('display_feedback', _handle_display_feedback)
	
	fade_delay_timer.connect('timeout', _handle_fade_delay_timer_timeout)

func _handle_display_feedback(feedback_type : String, _data : Dictionary) :
	
	var displaying_feedback : bool = false
	
	fade_delay_timer.wait_time = 2.0
	
	if feedback_type == 'alert_invalid_energy_left':
		invalid_energy_left_parent.visible = true
	
		await get_tree().create_timer(2.0).timeout
		
		invalid_energy_left_parent.visible = false 
	
	elif feedback_type == 'offer_sent' :
			
			fade_delay_timer.wait_time = 3.0
			
			displaying_feedback = true
			
			feedback_bg.color = Color.SKY_BLUE
			feedback_label.add_theme_color_override("font_color", Color.BLACK)
			feedback_label.text = 'OFFER SENT'
		
	if displaying_feedback : 
		
		if not feedback_display_parent.visible : 
			feedback_display_parent.visible = true
			fade_delay_timer.start()
		
func _handle_fade_delay_timer_timeout() :
	feedback_display_parent.visible = false
		
	
	
	
	
	
	
	
	
