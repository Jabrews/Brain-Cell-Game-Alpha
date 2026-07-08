extends InteractableBtn

@onready var handle_confirm_btn_pressed : Node = $"../HandleConfirmBtnPressed"


func _on_btn_interacted():
	handle_confirm_btn_pressed._handle_confirm_btn_pressed()
