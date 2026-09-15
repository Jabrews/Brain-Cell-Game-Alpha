
extends Node


# parent entry component
@onready var cell_entry_parent: GridContainer = $"../BreedingUI/CellLoader/CellCatalog/CenterContainer/ScrollContainer/GridContainerLeft"

# box components
@onready var left_main_box: Control = $"../BreedingUI/CellLoader/BreedingView/LeftBreedingViewMainBox"
@onready var right_main_box: Control = $"../BreedingUI/CellLoader/BreedingView/RightBreedingViewMainBox"
@onready var left_boost_box: Control = $"../BreedingUI/CellLoader/BreedingView/LeftBreedingViewBoostBox"
@onready var right_boost_box: Control = $"../BreedingUI/CellLoader/BreedingView/RightBreedingViewBoostBox"


# this happens every refresh or on inital open of breeder ui just
func _handle() -> void:
	
	GLBreedingComponetsBus.emit_signal("reset_borders")
	
	var panel_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_panel_state.duplicate()
	
	var boxes: Array[Control] = [
		left_main_box,
		right_main_box,
		left_boost_box,
		right_boost_box
	]
	
	
	for box: Control in boxes:
		
		var loaded_cell: BrainCell = box.loaded_cell
		
		# if box is empty do nothing
		if not loaded_cell:
			continue
		
		
		# get corresponding panel key
		# example: left + main = left_main
		var panel_key: String = box.side + "_" + box.box_type
		
		var panel_cell: BrainCell = panel_state.get(panel_key)
		
		
		# assume the cell is wanted unless it already matches physical panel
		var is_wanted: bool = true
		
		if panel_cell:
			if panel_cell.name == loaded_cell.name:
				is_wanted = false
		
		
		# cell entry border
		GLBreedingComponetsBus.emit_signal(
			"toggle_cell_entry_border",
			loaded_cell.name,
			box.box_type,
			is_wanted
		)
		
		
		# box border
		GLBreedingComponetsBus.emit_signal(
			"toggle_cell_box_border",
			box.box_type,
			box.side,
			is_wanted
		)
		
