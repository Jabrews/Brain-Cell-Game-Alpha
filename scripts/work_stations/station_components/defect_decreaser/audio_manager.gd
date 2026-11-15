extends Node

# audio
@onready var s_finished_charge : AudioStreamPlayer3D = $FinishedCharge
@onready var s_insufficent_funds : AudioStreamPlayer3D = $InsufficentFunds
@onready var s_invalid_cell : AudioStreamPlayer3D = $InvalidCell
 


func _ready() -> void:
	GLDefectDecreaserComponentBus.connect('play_sound', _handle_play_sound)

func _handle_play_sound(sound_type : String) : 
	match sound_type : 
		'finished_charge' : 
			s_finished_charge.play()
		'insufficent_funds' : 
			s_insufficent_funds.play()
		'invalid_cell' : 
			s_invalid_cell.play()
