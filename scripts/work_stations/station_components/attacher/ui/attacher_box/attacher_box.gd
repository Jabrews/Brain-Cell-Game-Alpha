extends Node

# components
@onready var display_mock_cell : Node = $DisplayMockCell
@onready var on_border : TextureRect = $OnBorder

var loaded_cell : BrainCell

func _load_cell(cell : BrainCell) :
	
	loaded_cell = cell
	
	# handle border
	if loaded_cell : 
		on_border.visible = true
	else :
		on_border.visible = false 
	
	display_mock_cell._display(loaded_cell)
