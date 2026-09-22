extends Node

# helper component
@onready var handle_boost_display : Node = $"../../HandleBoostDisplay"
@onready var reset_boost_display : Node = $"../../HandleBoostDisplay/ResetBoostDisplay"

func _handle() :
	
	var ui_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_ui_state.duplicate()
	
	var left_boost_cell : BrainCell = ui_state['left_boost']
	var left_main_cell = ui_state['left_main']
	var right_boost_cell : BrainCell = ui_state['right_boost']
	var right_main_cell = ui_state['right_main']
	
	# close because boost cell removed 
	if not left_boost_cell or not left_main_cell: 
		handle_boost_display._close_boost_display('left')
		
		if not left_boost_cell : 
			reset_boost_display._reset('left')
	
	if not right_boost_cell or not right_main_cell: 
		handle_boost_display._close_boost_display('right')
		
		if not right_boost_cell : 
			reset_boost_display._reset('right')
	
	# HACK
	# re-open to refresh, might have main cell now
	# get rid of hint
	if left_boost_cell and left_main_cell : 
		if handle_boost_display.left_add_main_cell_hint.visible == true : 
			handle_boost_display._handle('left')
	
	if right_boost_cell and right_main_cell : 
		if handle_boost_display.right_add_main_cell_hint.visible == true : 
			handle_boost_display._handle('right')
