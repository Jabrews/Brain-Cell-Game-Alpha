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
	
	var displaying_feedback : bool = false
	
	fade_delay_timer.wait_time = 2.0
	
	match feedback_type : 	
		'lock_alert' :
			locked_sprite._shake()		
			GLPrisonerProfilerComponentsBus.emit_signal('play_sound', 'lock_shake')
		
		'all_stats_disabled' : 
			
			displaying_feedback = true
			
			feedback_bg.color = Color.DARK_RED
			feedback_label.add_theme_color_override("font_color", Color.WHITE)
			feedback_label.text = 'INVALID - ALL STATS DISABLED'
		
		'exceeded_energy' : 
			displaying_feedback = true
			
			feedback_bg.color = Color.DARK_RED
			feedback_label.add_theme_color_override("font_color", Color.BLACK)
			feedback_label.text = 'INVALID - EXCEEDED ENERGY LEFT'
		
		'lock_warning' :
			
			fade_delay_timer.wait_time = 3.0
			
			displaying_feedback = true
			
			feedback_bg.color = Color.DARK_RED
			feedback_label.add_theme_color_override("font_color", Color.WHITE)
			feedback_label.text = 'INVALID - STAT IN LOCK RANGE'
		
		
	if displaying_feedback : 
		
		if not feedback_display_parent.visible : 
			feedback_display_parent.visible = true
			fade_delay_timer.start()
			
			
			
func _handle_fade_delay_timer_timeout() :
	feedback_display_parent.visible = false
	
