extends Area3D

# handle component
@onready var handle_display_ui : Node = $"../../Logic/HandleDisplayUi"


func _toggle_hologram_hint(toggle_value: bool) -> void:
	GLAttacherComponentBus.emit_signal('toggle_show_view_attacher_label', toggle_value)

func _handle_hologram_interacted() -> void:
	GLAttacherComponentBus.emit_signal('toggle_show_view_attacher_label', false)
	
	handle_display_ui._toggle_display(true)
