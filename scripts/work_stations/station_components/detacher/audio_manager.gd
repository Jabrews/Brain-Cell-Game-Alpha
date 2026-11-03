extends Node

# components
@onready var s_cycle : AudioStreamPlayer3D = $CycleStat
@onready var s_valid : AudioStreamPlayer3D = $ValidSelected
@onready var s_invalid : AudioStreamPlayer3D = $InvalidSelected
@onready var s_finished_charge : AudioStreamPlayer3D = $FinishedCharge


func _ready() -> void:
	GLDetacherComponentBus.connect('play_sound', _handle_play_sound)

func _handle_play_sound(sound_type : String) : 
	match sound_type : 
		'cycle' :
			s_cycle.play()
		'valid' : 
			s_valid.play()
		'invalid' : 
			s_invalid.play()
		'finished' :
			s_finished_charge.play()
