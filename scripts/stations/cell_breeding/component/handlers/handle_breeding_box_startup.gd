extends Node

# components
@onready var cell_entry_container: GridContainer = $"../BreedingUI/CellLoader/CellCatalog/CenterContainer/ScrollContainer/GridContainerLeft"

# reset btn component
@onready var reset_btn : Control = $"../BreedingUI/ExitHeader/ResetBtn"

# box components
@onready var left_main_box: Control = $"../BreedingUI/CellLoader/BreedingView/LeftBreedingViewMainBox"
@onready var right_main_box: Control = $"../BreedingUI/CellLoader/BreedingView/RightBreedingViewMainBox"
@onready var left_boost_box: Control = $"../BreedingUI/CellLoader/BreedingView/LeftBreedingViewBoostBox"
@onready var right_boost_box: Control = $"../BreedingUI/CellLoader/BreedingView/RightBreedingViewBoostBox"


func _handle() -> void:
	var ui_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_ui_state.duplicate()
	var panel_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_panel_state.duplicate()

	var load_state: Dictionary[String, BrainCell] = ui_state

	# if UI has never been populated, initialize from physical panel
	if not _state_has_cells(ui_state):
		load_state = panel_state

	_empty_all_boxes()

	for box_type: String in load_state:
		var cell: BrainCell = load_state[box_type]

		if not cell:
			continue

		var box: Control = get_box(box_type)

		if box:
			box._handle_entry_dropped(cell, false)
		
	GLBreedingComponetsBus.emit_signal("initate_breeder_refresh")

func _empty_all_boxes() -> void:
	left_main_box._handle_box_empty(false) # false just means dont play sound
	right_main_box._handle_box_empty(false)
	left_boost_box._handle_box_empty(false)
	right_boost_box._handle_box_empty(false)


func get_box(box_type: String) -> Control:
	match box_type:
		"left_main":
			return left_main_box
			
		"right_main":
			return right_main_box
			
		"left_boost":
			return left_boost_box
			
		"right_boost":
			return right_boost_box
			
		_:
			push_error("Couldn't find box type: ", box_type)
			return null


func _state_has_cells(state: Dictionary[String, BrainCell]) -> bool:
	for key: String in state:

		if state[key]:
			return true
	
	return false
