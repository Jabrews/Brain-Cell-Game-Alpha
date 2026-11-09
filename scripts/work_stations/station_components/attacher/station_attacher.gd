extends Node

# components
@onready var light_manager : Node = $Logic/LightManager
@onready var refresh_ui : Node = $Logic/RefreshUi

var enabled : bool = false 
var loaded_cell_container : CharacterBody3D


func _recieve_cell_container(cell_container : CharacterBody3D) : 
	reset_state()
	
	loaded_cell_container = cell_container	
	
	refresh_ui._refresh()
	
	light_manager._set_light_mode('green')
	

func _removed_cell_container(_cell_container : CharacterBody3D) : 
	
	reset_state()
	
	refresh_ui._refresh()
	
	light_manager._set_light_mode('off')

func reset_state() :
	loaded_cell_container = null
	pass

func _get_loaded_cell() -> BrainCell : 
	if loaded_cell_container : 
		return loaded_cell_container.designated_brain_cell
	else : 
		return null
