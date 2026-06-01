extends InteractableBtn 

# componnets
@onready var stat_control_parent : Node3D = $".."

func _on_btn_interacted():
	
	var toggle_value = !stat_control_parent.stat_on 
	
	stat_control_parent._handle_toggle_on_off(toggle_value) 
	
	
		
	
