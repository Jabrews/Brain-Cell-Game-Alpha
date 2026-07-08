extends InteractableBtn 

@export var direction : String 
@export var side : String
@export var handle_direction_btn_pressed : Node


func _on_btn_interacted():
	handle_direction_btn_pressed._handle_direction_btn_pressed(side, direction)
