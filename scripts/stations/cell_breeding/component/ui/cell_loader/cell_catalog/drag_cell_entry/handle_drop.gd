extends Node

# components
@onready var parent_drag_cell_entry : Control = $".."
@onready var display_background : ColorRect = $"../DisplayBackground"

# component boxes
@onready var selected_view_box : Control = $"../../../CellLoader/SelectedViewSlider/SlideContent/BoxSection/SelectedViewBox"
@onready var left_breeding_view_main_box : Control = $"../../../CellLoader/BreedingView/LeftBreedingViewMainBox"
@onready var right_breeding_view_main_box : Control = $"../../../CellLoader/BreedingView/RightBreedingViewMainBox"
@onready var left_breeding_view_boost_box : Control = $"../../../CellLoader/BreedingView/LeftBreedingViewBoostBox"
@onready var right_breeding_view_boost_box : Control = $"../../../CellLoader/BreedingView/RightBreedingViewBoostBox"

func _handle() :
	var loaded_cell : BrainCell = parent_drag_cell_entry.loaded_cell 
	
	# selected view box
	if display_background.get_global_rect().intersects(
		selected_view_box.display_background.get_global_rect()
	) :
		selected_view_box._handle_entry_dropped(loaded_cell)
	
	# left main box
	elif display_background.get_global_rect().intersects(
		left_breeding_view_main_box.display_background.get_global_rect()
	) :
		left_breeding_view_main_box._handle_entry_dropped(loaded_cell, true, true)
		
	# right main box
	elif display_background.get_global_rect().intersects(
		right_breeding_view_main_box.display_background.get_global_rect()
	) :
		right_breeding_view_main_box._handle_entry_dropped(loaded_cell, true, true)
	
	# left boost box
	elif display_background.get_global_rect().intersects(
		left_breeding_view_boost_box.display_background.get_global_rect()
	) :
		left_breeding_view_boost_box._handle_entry_dropped(loaded_cell, true, true)
	
	# right boost box
	elif display_background.get_global_rect().intersects(
		right_breeding_view_boost_box.display_background.get_global_rect()
	) :
		right_breeding_view_boost_box._handle_entry_dropped(loaded_cell, true, true)
	
	# default drop sound insues
	else : 
		GLBreedingComponetsBus.emit_signal('breeder_play_sound','dropped')
	
		
		
		
	
