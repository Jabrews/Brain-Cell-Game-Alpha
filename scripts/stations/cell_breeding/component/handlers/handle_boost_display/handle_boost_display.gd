extends Node

# visual components
@onready var left_boost_display : Control = $"../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay"
@onready var left_add_main_cell_hint : Control = $"../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay/AddMainCellHint"

# display component
@onready var display_boost_stats : Node = $DisplayBoostStats

# is called from boost box
func _handle(side : String) :
	
	var boost_cell : BrainCell	
	var main_cell : BrainCell
	var boost_display : Control 
	var add_a_cell_hint : Control
	
	match side : 
		'left' :
			boost_cell = GLBreedingComponetsBus.breeding_ui_state['left_boost']
			main_cell = GLBreedingComponetsBus.breeding_ui_state['left_main']
			boost_display = left_boost_display
			add_a_cell_hint = left_add_main_cell_hint
		'right' :
			boost_cell = GLBreedingComponetsBus.breeding_ui_state['right_boost']
			main_cell = GLBreedingComponetsBus.breeding_ui_state['left_main']
			boost_display = left_boost_display
			add_a_cell_hint = left_add_main_cell_hint
		_ : 
			push_error('unable to find corrisponding boost cell on side : ', side)
			boost_cell = null
			main_cell = null
	
	if not boost_cell: 
		return
	
	boost_display.visible = true
	
	display_boost_stats._display(boost_cell, side)
	
	# add a cell hint	
	if not main_cell : 
		add_a_cell_hint.visible = true
	else : 
		add_a_cell_hint.visible = false 

func _close_boost_display(side : String) :
	
	var boost_display : Control 
	
	match side : 
		'left' :
			boost_display = left_boost_display
		'right' :
			boost_display = left_boost_display
		_ : 
			push_error('unable to find corrisponding boost cell on side : ', side)
			boost_display = null
	
	boost_display.visible = false

	
	
	
	
	
	
	
