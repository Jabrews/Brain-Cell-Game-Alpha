extends Node


func _handle() -> void:
	
	# pick random cell 	
	var ran_cell : BrainCell = GLCellManagerBus.collected_cells_refrence.pick_random()	
	
	if not ran_cell : 	
		return
	
	else : 
		var cell_name: String =  ran_cell.name
		GLDefectEventMangerBus.emit_signal('initate_defect_event_cell_container', 'bubble', cell_name, false, {})
