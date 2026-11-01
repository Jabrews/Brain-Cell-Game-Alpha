extends Node

# components
@onready var refresh_displays : Node = $Logic/RefreshDisplays

var enabled : bool = false 
var loaded_cell_container : CharacterBody3D = null

var stat_selected_index : int = -1
var selected_stat : String = 'none'
var stat_valid : bool = false
var failure_rate : int = 0

func _ready() -> void:
	refresh_displays._refresh()


func _recieve_cell_container(cell_container : CharacterBody3D) : 
	reset_state()
	
	loaded_cell_container = cell_container	
	
	refresh_displays._refresh()
	

func _removed_cell_container(_cell_container : CharacterBody3D) : 
	
	reset_state()
	
	refresh_displays._refresh()
	
	
	
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
