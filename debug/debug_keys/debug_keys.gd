extends Node



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') :	
		#GLGameManagerBus.emit_signal('proceed_next_round')
		pass
	
	
	if Input.is_action_just_pressed('debug2') :	
		pass
