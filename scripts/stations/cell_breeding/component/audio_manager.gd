extends Node

@onready var s_drag_dropped : AudioStreamPlayer3D = $DragDropped
@onready var s_box_accepted : AudioStreamPlayer3D = $BoxAccepted
@onready var s_box_removed : AudioStreamPlayer3D = $RemoveFromBox
@onready var s_error : AudioStreamPlayer3D = $Error


func _ready() -> void:
	GLBreedingComponetsBus.connect('breeder_play_sound', _handle_breeder_play_sound)

func _handle_breeder_play_sound(sound_type : String) :
	
	match sound_type : 
		'dropped' :
			s_drag_dropped.play()
		'box_accepted' :
			s_box_accepted.play()
		'box_removed' :
			s_box_removed.play()
		'error' : 
			s_error.play()
		_ : 
			push_error('trouble finding breeder sound : ', sound_type)
			return
