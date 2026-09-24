extends Area3D

# handle component
@onready var handle_display_ui : Node = $"../../HandleDisplayUi"



func _toggle_hologram_hint(toggle_value: bool) -> void:
	GLBreedingComponetsBus.emit_signal('toggle_show_view_breeder_label', toggle_value)

func _handle_hologram_interacted() -> void:
	GLBreedingComponetsBus.emit_signal('toggle_show_view_breeder_label', false)
	handle_display_ui._toggle_display(true)
