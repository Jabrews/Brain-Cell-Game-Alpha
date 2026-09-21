extends Node

# helper component
@onready var handle_boost_display : Node = $"../../HandleBoostDisplay"

func _handle() :
	
	var panel_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_panel_state.duplicate()
	
	var left_boost_cell : BrainCell = panel_state['left_boost']
	var right_boost_cell : BrainCell = panel_state['right_boost']
	
	if not left_boost_cell : 
		handle_boost_display._close_boost_display('left')
	
	if not right_boost_cell : 
		handle_boost_display._close_boost_display('right')
		
	
	
