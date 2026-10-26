extends Node

# cinnaamtic active stuff
# mainly for event notice rn
var cinnamatic_active : bool = false
signal toggle_cinnamatic_active(toggle_value : bool)

func _ready() -> void:
	connect('toggle_cinnamatic_active', _handle_toggle_cinnamatic_active)

func _handle_toggle_cinnamatic_active(toggle_value : bool) :
	cinnamatic_active = toggle_value


# cinnamatic signals
signal toggle_extractor_cinnamatic(toggle_value : bool)

signal toggle_goal_cinnamtic(toggle_value : bool)

signal toggle_offer_picked_cinnamatic(toggle_value : bool)
	
	
	
	

		
	
	
