extends InteractableBtn 

@export var prisoner_quanity : int = 0

# componnets
@export var parent_prisoner_profiler : Node3D 

func _on_btn_interacted():
	parent_prisoner_profiler._update_prisoner_quanity(prisoner_quanity)
	get_parent()._prisoner_quanity_btn_selected(prisoner_quanity)
