extends Node

# components
@onready var cinnamatic_manager : Node = $"../CinnamaticManager"
#@onready var display_turns_left : Node = $"../DisplayTurnsLeft"
@onready var parent_offer_tablet : Node = $".."


func _toggle(toggle_value : bool) :
	
	if toggle_value : 	
		
		cinnamatic_manager._start_cinnamatic()
		
		parent_offer_tablet._start()
		
	
	else : 
		cinnamatic_manager._end_cinnamatic()
	
	
