extends Node

# components
@onready var refresh_displays : Node = $Logic/RefreshDisplays
@onready var light_manager : Node = $Logic/LightManager

var enabled : bool = false 
var loaded_cell_container : CharacterBody3D = null
var cell_just_added : bool = false # for failure chance screen

var stat_selected_index : int = -1
var selected_stat : String = 'none'
var stat_valid : bool = false
var failure_rate : int = 0

func _ready() -> void:
	refresh_displays._refresh()
	
	light_manager._set_light_mode('off')


func _recieve_cell_container(cell_container : CharacterBody3D) : 
	reset_state()
	
	loaded_cell_container = cell_container	
	
	cell_just_added = true
	
	refresh_displays._refresh()
	
	light_manager._set_light_mode('green')
	

func _removed_cell_container(_cell_container : CharacterBody3D) : 
	
	reset_state()
	
	cell_just_added = false
	
	refresh_displays._refresh()
	
	light_manager._set_light_mode('off')
	
	
	
func reset_state() : 
	stat_selected_index = -1
	selected_stat = 'none'
	stat_valid = false
	loaded_cell_container = null
	failure_rate = 0


func _get_loaded_cell() -> BrainCell : 
	if loaded_cell_container : 
		return loaded_cell_container.designated_brain_cell
	else : 
		return null
