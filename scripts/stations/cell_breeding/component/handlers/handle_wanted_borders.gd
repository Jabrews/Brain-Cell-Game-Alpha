extends Node


# parent entry component
@onready var cell_entry_parent : GridContainer = $"../BreedingUI/CellLoader/CellCatalog/CenterContainer/ScrollContainer/GridContainerLeft"

# box components
@onready var left_main_box: Control = $"../BreedingUI/CellLoader/BreedingView/LeftBreedingViewMainBox"
@onready var right_main_box: Control = $"../BreedingUI/CellLoader/BreedingView/RightBreedingViewMainBox"
@onready var left_boost_box: Control = $"../BreedingUI/CellLoader/BreedingView/LeftBreedingViewBoostBox"
@onready var right_boost_box: Control = $"../BreedingUI/CellLoader/BreedingView/RightBreedingViewBoostBox"

# this happens every refresh or on inital open of breeder ui just
func _handle(): 
	
	# go through each box and look at their loaded cell
	var boxes : Array[Control] = [left_boost_box, right_main_box, left_boost_box, right_boost_box]
	
	return
	
	
	
	
	# logic

		# if no loaded cell return
		# if cell exist, loop through panel_state_dict looking for loaded cell's name
			# IMPORTANT we dont care which seat side a cell is in (left or right)
		# if we find it 
			# TODO fix cell entry border function to now auto turn off all other borders when called.
				# TODO when dealing with the above, if toggle_value == false. just reset and dont bother with toggle 
			# 1. use signal on cell_entry to activate border 
			# 2. look at box directly and select correct border # TODO how to approach this
			
	
	
	
	
	
	
	
		
	
	
