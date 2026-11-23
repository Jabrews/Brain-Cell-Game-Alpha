extends InteractableBtn

# components
@onready var elevator_manager : Node = $"../../ElevatorManager"

func _on_btn_interacted():
	elevator_manager._handle_confirm_btn_pressed()
