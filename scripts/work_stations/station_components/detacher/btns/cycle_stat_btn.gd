extends InteractableBtn

# components
@onready var handle_cycle_stat_btn : Node = $"../../Logic/BtnHandlers/HandleCycleStatBtn"

@export var direction : int = 1

func _on_btn_interacted():
	handle_cycle_stat_btn._handle(direction)
