extends Node

# componnets
@onready var stat_display : Control = $"../StatDisplay"
@onready var off_display : Control = $"../OffDisplay"
@onready var parent_display : Node2D = $".."
# feedback
@onready var feedback_display : Control = $"../FeedbackDisplay"
@onready var feedback_bg : ColorRect = $"../FeedbackDisplay/FeedbackBG"
@onready var feedback_label : Label = $"../FeedbackDisplay/FeedbackLabel"



func _ready() -> void:	
	GLPrisonerProfilerComponentsBus.connect('station_feedback_requested', _handle_feedback_requested)

func _switch(screen_type : String) :

	toggle_screens_off()
	
	match screen_type :	
		'on' : 
			stat_display.visible = true
		'off' :
			off_display.visible = true
func toggle_screens_off() :
	stat_display.visible = false
	off_display.visible = false


func show_feedback_screen(text: String, background_color : Color) :
	feedback_bg.color = background_color
	feedback_label.text = text
	
	feedback_display.visible = true
	
	await get_tree().create_timer(3.0).timeout
	
	feedback_display.visible = false	
	
func _handle_feedback_requested(type : String, data : Dictionary) :
	
	match type :
		'error_prisoner_quanity' :
			show_feedback_screen('select prisoner quanity', Color.RED)
		'error_locked_stat' :
			if parent_display.selected_stat_type == data['stat_type'] :
				show_feedback_screen('value inside locked area', Color.GRAY)
		'error_all_stats_disabled' :
			show_feedback_screen('all stats disabled', Color.RED)
		'error_not_enough_energy' :
			show_feedback_screen('invalid energy', Color.YELLOW)
		'batch_created' :
			show_feedback_screen('batch created', Color.CADET_BLUE)
		'prisoner_quanity_not_selected' :
			show_feedback_screen('select prisoner quanity', Color.RED)
	
	
