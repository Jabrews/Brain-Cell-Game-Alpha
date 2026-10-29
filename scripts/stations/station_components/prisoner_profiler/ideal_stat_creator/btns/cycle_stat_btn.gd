extends InteractableBtn 

@export var cycle_direction : String = 'up'



# parent handler
@onready var handle_cycle_stat_btn : Node = $"../../../../Logic/IdealStatCreator/BtnHandlers/HandleCycleStatBtn"


func _on_btn_interacted():
	handle_cycle_stat_btn._handle(cycle_direction)
