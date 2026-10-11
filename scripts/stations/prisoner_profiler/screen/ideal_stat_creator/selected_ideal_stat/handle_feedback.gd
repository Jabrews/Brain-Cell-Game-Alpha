extends Node

# feedback comp 
@onready var feedback_display_parent : Control = $"../FeedbackDisplay"
@onready var feedback_bg : ColorRect = $"../FeedbackDisplay/FeedbackBG"
@onready var feedback_label : Label = $"../FeedbackDisplay/FeedbackLabel"
@onready var fade_delay_timer : Timer = $FadeDelayTimer
# lock alert comp
@onready var locked_sprite : Sprite2D = $"../StatDisplay/Locked/LockedSprite"

func _ready() -> void:
	GLPrisonerProfilerComponentsBus.connect('display_feedback', _handle_display_feedback)
	
	fade_delay_timer.connect('timeout', _handle_fade_delay_timer_timeout)
	

func _handle_display_feedback(feedback_type : String, _data : Dictionary) :
	
	# lock alert is exception
	if feedback_type != 'lock_alert' : 
		feedback_display_parent.visible = true
		
		fade_delay_timer.stop()
		fade_delay_timer.start()
	
	match feedback_type : 	
		'lock_alert' :
			locked_sprite._shake()		
			
			
func _handle_fade_delay_timer_timeout() :
	feedback_display_parent.visible = false
	
