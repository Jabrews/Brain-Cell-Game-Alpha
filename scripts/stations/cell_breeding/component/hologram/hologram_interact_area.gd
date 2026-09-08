extends Area3D


func _toggle_hologram_hint(toggle_value: bool) -> void:
	GLBreedingComponetsBus.emit_signal('toggle_show_view_breeder_label', toggle_value)

func _handle_hologram_interacted() -> void:
	pass
