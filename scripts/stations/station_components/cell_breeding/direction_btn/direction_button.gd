extends InteractableBtn 

@export var direction : String 
@export  var charge_seat_parent : Node3D 

@onready var direction_button_controller : Node = $"../../../../../DirectionBtnController"


func _on_btn_interacted():
	
	
	var side = charge_seat_parent.side
	
	direction_button_controller._handle_direction_btn_pressed(side, direction)
