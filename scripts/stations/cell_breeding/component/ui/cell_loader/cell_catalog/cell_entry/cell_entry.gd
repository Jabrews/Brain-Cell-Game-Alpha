extends Node


# helper components
@onready var display_cell_entry : Node = $DisplayCellEntry
@onready var handle_status_symbols : Node = $HandleStatusSymbols

var loaded_cell : BrainCell


func _load_cell(cell : BrainCell) :
	
	loaded_cell = cell	
	
	display_cell_entry._display(cell)
	handle_status_symbols._handle(cell)

func _handle_mouse_entered() :
	pass

func _handle_mouse_exited() :
	pass
