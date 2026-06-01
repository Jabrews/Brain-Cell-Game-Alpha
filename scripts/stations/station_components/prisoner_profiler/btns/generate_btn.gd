extends InteractableBtn

@onready var prisoner_profiler_parent : Node3D = $".."

func _on_btn_interacted():
	prisoner_profiler_parent._create_prisoners()
