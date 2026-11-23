extends InteractableBtn

# components
@onready var parent_defect_decreaser : Node3D = $"../.."
@onready var handle_confirm_btn : Node = $"../../Logic/BtnHandlers/HandleConfirmBtn"

func _on_btn_interacted():
	handle_confirm_btn._handle()
	
	
