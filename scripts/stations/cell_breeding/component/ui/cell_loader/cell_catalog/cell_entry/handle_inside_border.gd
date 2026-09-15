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

func _handle_toggle_cell_entry_border(cell_name : String, border_type : String, toggle_value : bool) :
	
	var loaded_cell_name = parent_cell_entry.loaded_cell.name
	
	if loaded_cell_name != cell_name : 
		return
	
	reset()
	
	# no reason to continue just turn all off
	if toggle_value == false :
		return
	
	var border : TextureRect 	
	
	match border_type  :
		'on_selected':  
			border = on_selected_border
		'wanted_main' : 
			border = wanted_main_border
		'on_main' :
			border = on_main_border
		'wanted_boost': 
			border = wanted_boost_border
		'on_boost' : 
			border = on_boost_border
		
		
	border.visible = toggle_value
	
func reset() :	
	on_boost_border.visible = false
	on_main_border.visible = false
	wanted_boost_border.visible = false
	wanted_main_border.visible = false
	on_selected_border.visible = false
	
	
	
	
	
	
	
	
