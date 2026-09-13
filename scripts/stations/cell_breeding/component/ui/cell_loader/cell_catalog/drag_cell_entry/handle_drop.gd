extends Node

# components
@onready var parent_drag_cell_entry : Control = $".."
@onready var display_background : ColorRect = $"../DisplayBackground"

# component boxes
@onready var selected_view_box : Control = $"../../../CellLoader/SelectedView/SelectedViewBox"

func _handle() :
	var loaded_cell : BrainCell = parent_drag_cell_entry.loaded_cell 
	
	# dropped on selected view box
	if display_background.get_global_rect().intersects(
		selected_view_box.display_background.get_global_rect()
	) :
		selected_view_box._handle_entry_dropped(loaded_cell)
	
	
	# default drop sound insues
	else : 
		GLBreedingComponetsBus.emit_signal('breeder_play_sound','dropped')
	
		
		
		
	
