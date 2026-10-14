extends Node

# components
@onready var cinnamatic_manager : Node = $"../CinnamaticManager"


func _toggle(toggle_value : bool) :
	
	if toggle_value : 	
		cinnamatic_manager._start_cinnamatic()
	
	else : 
		cinnamatic_manager._end_cinnamatic()
	
	
