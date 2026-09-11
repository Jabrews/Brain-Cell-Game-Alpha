extends Node


# helper components
@onready var display_cell_entry : Node = $DisplayCellEntry
@onready var handle_status_symbols : Node = $HandleStatusSymbols

func _load_cell(cell : BrainCell) :
	display_cell_entry._display(cell)
	handle_status_symbols._handle(cell)

func _handle_mouse_entered() :
	pass

func _handle_mouse_exited() :
	pass
