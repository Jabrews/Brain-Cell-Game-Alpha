extends InteractableBtn 

@export var cycle_type : String
@export var increment_type : String

# components
@onready var parent_round_controller : Node3D = $".."

func _on_btn_interacted() :
	parent_round_controller._handle_round_controller_increment_up_btn(cycle_type, increment_type)
