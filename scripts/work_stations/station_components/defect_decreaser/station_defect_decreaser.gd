extends Node

# components
@onready var compute_reduction_context : Node = $Logic/ComputeReductionContext
@onready var light_manager : Node = $Logic/LightManager
@onready var refresh_displays : Node = $Logic/RefreshDisplays


var loaded_cell_container : CharacterBody3D
var enabled : bool = false 

var defect_reduction_context : DefectReductionContext = null

func _ready() -> void:
	refresh_displays._refresh()

func _recieve_cell_container(cell_container : CharacterBody3D) : 
	loaded_cell_container = cell_container	
	
	var loaded_cell : BrainCell = _get_loaded_cell()
	defect_reduction_context = compute_reduction_context._compute(loaded_cell)
	
	# handle light
	if defect_reduction_context.valid : 
		light_manager._set_light_mode('green')
	else : 
		light_manager._set_light_mode('blink_red')
	
	# refresh displays
	refresh_displays._refresh()
	

func _removed_cell_container(_cell_container : CharacterBody3D) : 
	loaded_cell_container = null
	
	defect_reduction_context = null
	
	# handle light
	light_manager._set_light_mode('off')
	
	# refresh displays
	refresh_displays._refresh()
	
	
func _get_loaded_cell() -> BrainCell : 
	if loaded_cell_container : 
		return loaded_cell_container.designated_brain_cell
	else : 
		return null
