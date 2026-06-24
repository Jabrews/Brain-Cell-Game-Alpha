extends InteractableBtn

@onready var prisoner_profiler_parent : Node = $"../.."

func _on_btn_interacted():
	prisoner_profiler_parent.handle_generate_btn_pressed()
