extends Node

# components
@onready var s_item_added : AudioStreamPlayer3D = $ItemAdded
@onready var s_item_removed : AudioStreamPlayer3D = $ItemRemoved


func _ready() -> void:
	GLJarComponentBus.connect('play_sound', _handle_play_sound)

func _handle_play_sound(sound_type : String) :
	match sound_type : 
		'item_added' : #un_used
			s_item_added.play()
		'item_removed' :
			s_item_removed.play()
