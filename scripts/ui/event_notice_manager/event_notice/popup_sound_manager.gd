extends Node

@onready var s_default : AudioStreamPlayer2D = $Default
@onready var s_emergency: AudioStreamPlayer2D = $Emergency

func _play(event_type : String) : 
	if event_type == 'defect_event' or event_type == 'mutation_event' : 
		s_emergency.play()
	else : 
		s_default.play()
