extends Node

# components
@onready var parent_panel : Area3D = $"../.."
@onready var parent_light_manager : StaticBody3D = $".."

var corrisponding_type : String
var corrisponding_side : String


func _ready() -> void:
	corrisponding_type = parent_panel.type
	corrisponding_side = parent_panel.side
	
	GLBreedingComponetsBus.connect("toggle_cell_picked_up", _toggle_cell_picked_up)


func _toggle_cell_picked_up(toggle_value : bool, cell_name : String) -> void:
	
	var dic_key : String = (
		corrisponding_side + "_" + corrisponding_type
	)
	
	var ui_wanted_cell : BrainCell = (
		GLBreedingComponetsBus.breeding_ui_state[dic_key]
	)
	
	if not ui_wanted_cell:
		parent_light_manager._flash_lights(false)
		return
	
	# ignore cells that this panel does not want
	if ui_wanted_cell.name != cell_name:
		return
	
	# picked up = start flashing
	if toggle_value:
		parent_light_manager._flash_lights(true)
	
	# dropped = stop flashing
	else:
		parent_light_manager._flash_lights(false)
