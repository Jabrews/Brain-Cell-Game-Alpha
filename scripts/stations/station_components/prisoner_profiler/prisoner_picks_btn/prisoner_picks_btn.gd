extends InteractableBtn 

@export var prisoner_picks : int = 0

# componnets
@export var parent_prisoner_profiler : Node3D 

func _on_btn_interacted():
	parent_prisoner_profiler._update_prisoner_picks(prisoner_picks)
	get_parent()._prisoner_picks_btn_selected(prisoner_picks)
