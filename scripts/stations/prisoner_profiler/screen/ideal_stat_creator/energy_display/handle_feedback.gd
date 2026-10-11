extends Node

@onready var invalid_energy_left_parent : Control = $"../FeedbackInvalidEnergyLeft"


func _ready() -> void:
	GLPrisonerProfilerComponentsBus.connect('display_feedback', _handle_display_feedback)

func _handle_display_feedback(feedback_type : String, _data : Dictionary) :
	if feedback_type == 'alert_invalid_energy_left':
		invalid_energy_left_parent.visible = true
	
		await get_tree().create_timer(2.0).timeout
		
		invalid_energy_left_parent.visible = false 
		
		
	
	
	
	
	
	
	
	
