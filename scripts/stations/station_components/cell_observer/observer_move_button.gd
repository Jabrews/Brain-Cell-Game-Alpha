extends InteractableBtn 

@export var button_side : String
@onready var cell_observer_parent : Node3D = $".."

func _on_btn_interacted():
	cell_observer_parent._move_button_pressed(button_side)
