extends InteractableBtn 

@export var increment_direction : String

# componnets
@onready var stat_control_parent : Node3D = $"../.."

func _on_btn_interacted():
	stat_control_parent._handle_stat_increment_btn(increment_direction)
