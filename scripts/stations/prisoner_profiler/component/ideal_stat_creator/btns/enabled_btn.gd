extends InteractableBtn

# parent handler
@onready var handle_enabled_btn : Node = $"../../../../Logic/IdealStatCreator/BtnHandlers/HandleEnabledBtn"

func _on_btn_interacted(): 
	handle_enabled_btn._handle()
