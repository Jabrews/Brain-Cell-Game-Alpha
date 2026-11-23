extends Node

# components
@onready var handle_display_ui : Node = $"../../HandleDisplayUi"

func _handle() :
	handle_display_ui._toggle_display(false)
