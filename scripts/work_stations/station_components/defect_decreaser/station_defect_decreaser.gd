extends Node

var loaded_cell_container : CharacterBody3D
var enabled : bool = true


func _recieve_cell_container(cell_container : CharacterBody3D) : 
	#reset_state()
	
	loaded_cell_container = cell_container	
	
	#refresh_displays._refresh()
	
	#light_manager._set_light_mode('green')
	

func _removed_cell_container(_cell_container : CharacterBody3D) : 
	
	#reset_state()
	
	loaded_cell_container = null
	
	#refresh_displays._refresh()
#	
	#light_manager._set_light_mode('off')
	
