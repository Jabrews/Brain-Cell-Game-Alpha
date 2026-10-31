extends Node


var enabled : bool = false

var stat_selected : String = 'none'
var stat_valid : bool = false
var loaded_cell_container : CharacterBody3D = null
var failure_rate : int = 0




func _get_loaded_cell() -> BrainCell : 
	if loaded_cell_container : 
		return loaded_cell_container.designated_brain_cell
	else : 
		push_error('attempting to get brain cell from non-existing container: ', loaded_cell_container)
		return null
