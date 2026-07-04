extends InteractableBtn 

@export var cycle_direction : String 

# components
@onready var parent_charge_seat : Node3D = $"../../.."

func _on_btn_interacted():
	parent_charge_seat._handle_cycle_btn_pressed(cycle_direction)
