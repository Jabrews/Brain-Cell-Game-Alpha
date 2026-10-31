extends InteractableBtn

# components
@onready var handle_confirm_btn : Node = $"../../Logic/BtnHandlers/HandleConfirmBtn"

@export var direction : int = 1

func _on_btn_interacted():
	handle_confirm_btn._handle()
