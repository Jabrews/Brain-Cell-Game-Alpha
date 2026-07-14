extends InteractableBtn

# componnets
@onready var handle_safe_mode : Node = $"../../Logic/HandleSafeMode"



func _on_btn_interacted():
	handle_safe_mode._safe_mode_lever_switched()
	
		
