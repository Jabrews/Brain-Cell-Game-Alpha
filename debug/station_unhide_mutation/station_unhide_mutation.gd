extends Node



func _handle_panel_body_recieved(brain_cell_container : CharacterBody3D) :
	
	if brain_cell_container : 	
		var active_brain_cell : BrainCell = brain_cell_container.designated_brain_cell
		if active_brain_cell.mutation : 
			if active_brain_cell.mutation.hidden :
				GLCellManagerBus.emit_signal('debug_unhide_collected_cell_mutation', active_brain_cell)
					
		
		
	
	
