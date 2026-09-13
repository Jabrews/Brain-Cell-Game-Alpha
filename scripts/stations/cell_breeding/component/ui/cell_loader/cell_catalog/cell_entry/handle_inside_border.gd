extends Node

# components
@onready var parent_cell_entry : Control = $".."

# border components
@onready var on_selected_border : TextureRect = $"../InsideBorderEffects/OnSelected"


func _ready() -> void:
	GLBreedingComponetsBus.connect('toggle_cell_entry_border', _handle_toggle_cell_entry_border)

func _handle_toggle_cell_entry_border(cell_name : String, border_type : String, toggle_value : bool) :
	
	var loaded_cell_name = parent_cell_entry.loaded_cell.name
	
	if loaded_cell_name != cell_name : 
		return
	
	var border : TextureRect 	
	
	match border_type  :
		'on_selected':  
			border = on_selected_border
	
	border.visible = toggle_value
	
	
	
	
	
	
	
	
	
	
