extends Area3D

# handle component
@onready var parent_file_cabinet : Node3D = $".."

# VERY HACKY. STEALING HOLOGRAM CAST
# TODO make both holo and cabinet use the same
func _toggle_hologram_hint(toggle_value: bool) -> void:
	GLMutationFileCabinetBus.emit_signal('toggle_player_entered_cabinet_area', toggle_value)

func _handle_hologram_interacted() -> void:
	GLMutationFileCabinetBus.emit_signal('toggle_player_entered_cabinet_area', false)
	parent_file_cabinet._handle_cabinet_interacted()
