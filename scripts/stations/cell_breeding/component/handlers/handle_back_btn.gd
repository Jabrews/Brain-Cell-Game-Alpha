extends Node

# components
@onready var display_new_cell_preview : Node = $"../DisplayNewCellPreview"

func _handle() :#
	display_new_cell_preview._close()
