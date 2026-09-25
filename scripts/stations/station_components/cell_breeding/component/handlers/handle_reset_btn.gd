extends Node

# reset btn component
@onready var reset_btn : Control = $"../BreedingUI/ExitHeader/ResetBtn"

# box components
@onready var left_main_box: Control = $"../BreedingUI/CellLoader/BreedingView/Boxes/LeftBreedingViewMainBox"
@onready var right_main_box: Control = $"../BreedingUI/CellLoader/BreedingView/Boxes/RightBreedingViewMainBox"
@onready var left_boost_box: Control = $"../BreedingUI/CellLoader/BreedingView/Boxes/LeftBreedingViewBoostBox"
@onready var right_boost_box: Control = $"../BreedingUI/CellLoader/BreedingView/Boxes/RightBreedingViewBoostBox"

# breeding ui parent
@onready var exit_btn : ColorRect = $"../BreedingUI/ExitHeader/ExitBtn"

func _handle(): 
	
	var panel_state: Dictionary[String, BrainCell] = GLBreedingComponetsBus.breeding_panel_state.duplicate()
	
	_empty_all_boxes()
	
	for box_type: String in panel_state:
		var cell: BrainCell = panel_state[box_type]

		if not cell:
			continue

		var box: Control = get_box(box_type)

		if box:
			box._handle_entry_dropped(cell, false)
		
	GLBreedingComponetsBus.emit_signal("initate_breeder_refresh")

	exit_btn.grab_focus()

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

		
	
	
	
func _empty_all_boxes() -> void:
	
	left_main_box.prevent_interact = false
	right_main_box.prevent_interact = false
	
	left_main_box._handle_box_empty(false) # false just means dont play sound
	right_main_box._handle_box_empty(false)
	left_boost_box._handle_box_empty(false)
	right_boost_box._handle_box_empty(false)
	
