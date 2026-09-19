extends Node


# parent entry component
@onready var cell_entry_parent: GridContainer = $"../../BreedingUI/CellLoader/CellCatalog/CenterContainer/ScrollContainer/GridContainerLeft"

# box components
@onready var left_main_box: Control = $"../../BreedingUI/CellLoader/BreedingView/Boxes/LeftBreedingViewMainBox"
@onready var right_main_box: Control =$"../../BreedingUI/CellLoader/BreedingView/Boxes/RightBreedingViewMainBox"
@onready var left_boost_box: Control = $"../../BreedingUI/CellLoader/BreedingView/Boxes/LeftBreedingViewBoostBox"
@onready var right_boost_box: Control =$"../../BreedingUI/CellLoader/BreedingView/Boxes/RightBreedingViewBoostBox"


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
		
		
		# check if this cell already exists on either side
		# of the same box type
		var is_on_panel: bool = false
		
		if box.box_type == "main":
			
			var left_cell: BrainCell = panel_state.get("left_main")
			var right_cell: BrainCell = panel_state.get("right_main")
			
			if left_cell and left_cell.name == loaded_cell.name:
				is_on_panel = true
			
			if right_cell and right_cell.name == loaded_cell.name:
				is_on_panel = true
		
		elif box.box_type == "boost":
			
			var left_cell: BrainCell = panel_state.get("left_boost")
			var right_cell: BrainCell = panel_state.get("right_boost")
			
			if left_cell and left_cell.name == loaded_cell.name:
				is_on_panel = true
			
			if right_cell and right_cell.name == loaded_cell.name:
				is_on_panel = true
		
		
		var is_wanted: bool = not is_on_panel
		
		
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
