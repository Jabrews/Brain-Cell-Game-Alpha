extends Node


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') :	
		print(len(GLCellManagerBus.collected_cells_refrence))
			
	if Input.is_action_just_pressed('debug2') :	
		pass
