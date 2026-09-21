extends Node

# visual components
@onready var left_boost_display : Control = $"../BreedingUI/CellLoader/BreedingView/BoostDisplays/LeftBoostDisplay"

# is called from boost box
func _handle(side : String) :
	
	var cell : BrainCell	
	var boost_display : Control 
	
	match side : 
		'left' :
			cell = GLBreedingComponetsBus.breeding_ui_state['left_boost']
			boost_display = left_boost_display
		'right' :
			cell = GLBreedingComponetsBus.breeding_ui_state['right_boost']
			boost_display = left_boost_display
		_ : 
			push_error('unable to find corrisponding boost cell on side : ', side)
			cell = null
	
	if not cell : 
		return
	
	boost_display.visible = true

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

	
	
	
	
	
	
	
