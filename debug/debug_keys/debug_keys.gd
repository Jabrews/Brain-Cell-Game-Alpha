extends Node


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') :	
		for cell in GLCellManagerBus.collected_cells_refrence : 
			print('cell : ', cell.name)
			
	if Input.is_action_just_pressed('debug2') :	
		pass
