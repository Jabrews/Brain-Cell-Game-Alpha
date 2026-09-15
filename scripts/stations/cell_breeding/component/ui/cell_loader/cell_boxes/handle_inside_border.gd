extends Node

# components
@onready var parent_cell_entry : Control = $".."

# border components
@onready var on_selected_border : TextureRect = $"../InsideBorderEffects/OnSelected"
@onready var on_main_border : TextureRect = $"../InsideBorderEffects/OnMain"
@onready var wanted_main_border : TextureRect = $"../InsideBorderEffects/WantedMain"
@onready var on_boost_border : TextureRect = $"../InsideBorderEffects/OnBoost"
@onready var wanted_boost_border : TextureRect = $"../InsideBorderEffects/WantedBoost"



func _ready() -> void:
	GLBreedingComponetsBus.connect('toggle_cell_entry_border', _handle_toggle_cell_entry_border)
	GLBreedingComponetsBus.connect('reset_borders', _handle_reset_borders)

func _handle_reset_borders() :
	reset()

func _handle_toggle_cell_entry_border(cell_name : String, border_type : String, is_wanted : bool) :
	
	var loaded_cell_name = parent_cell_entry.loaded_cell.name
	
	if loaded_cell_name != cell_name : 
		return
	
	reset()
	
	var border : TextureRect 	
	
	match border_type  :
		'boost' : 
			if is_wanted : 
				border = wanted_boost_border
			else : 
				border = on_boost_border
		'main' :
			if is_wanted : 
				border = wanted_main_border
			else : 
				border = on_main_border
		'selected':  
			border = on_selected_border
		_ : 
			push_error('couldnt find border type  : ', border_type)
			border = on_selected_border
	
	border.visible = true
	
func reset() :	
	on_boost_border.visible = false
	on_main_border.visible = false
	wanted_boost_border.visible = false
	wanted_main_border.visible = false
	on_selected_border.visible = false
	
	
	
	
	
	
	
	
