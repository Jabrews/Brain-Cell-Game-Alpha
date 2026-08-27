extends InteractableBtn

@onready var handle_back_btn_pressed : Node = $"../HandleBackBtnPressed"

func _on_btn_interacted():
	handle_back_btn_pressed._handle_back_btn_pressed()
