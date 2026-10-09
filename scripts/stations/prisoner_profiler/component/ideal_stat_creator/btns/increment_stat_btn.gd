extends InteractableBtn

@export var increment_direction : String = 'up'

# parent handler
@onready var handle_increment_stat_btn : Node = $"../../../../Logic/IdealStatCreator/BtnHandlers/HandleIncrementStatBtn"


func _on_btn_interacted():
	handle_increment_stat_btn._handle(increment_direction)
