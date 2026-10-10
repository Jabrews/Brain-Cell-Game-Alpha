extends InteractableBtn 

# parent handler
@onready var handle_finished_btn : Node = $"../../../../Logic/IdealStatCreator/BtnHandlers/HandleFinishedBtn"


func _on_btn_interacted():
	handle_finished_btn._handle()
