extends InteractableBtn

@onready var parent_pris_spawner: Node3D = get_parent()

func _on_btn_interacted():
	parent_pris_spawner.handle_pris_spawn_btn_pressed()
