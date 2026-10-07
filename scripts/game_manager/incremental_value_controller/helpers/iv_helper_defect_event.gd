extends Node


@warning_ignore("shadowed_global_identifier")
func _update_defect_events(round: int, goal_piece: int) -> void:
	
	if round == 1:
		pass
	
	update_defect_events(round, goal_piece)


@warning_ignore("shadowed_global_identifier")
func update_defect_events(round: int, goal_piece: int) -> void:
	
	if round == 1:
		match goal_piece:
				1:
					IVDefectEventManager.inital_wait_time = 60.0
					IVDefectEventManager.defect_event_trigger_wait_time = 20.0
					IVDefectEventManager.defect_events_avaible = [
						DefectEvent.new('sickness_cell_container', 15),
						DefectEvent.new('jolt_single_hidden_interpreter', 20)
					]

				
				2:
					IVDefectEventManager.inital_wait_time = 30.0
					IVDefectEventManager.defect_event_trigger_wait_time = 17.0
					IVDefectEventManager.defect_events_avaible = [
						DefectEvent.new('sickness_cell_container', 25),
						DefectEvent.new('jolt_single_hidden_interpreter', 15),
						DefectEvent.new('bubble_cell_container', 25),
					]
				
					
				
				3:
					IVDefectEventManager.inital_wait_time = 30.0
					IVDefectEventManager.defect_event_trigger_wait_time = 15.0
					IVDefectEventManager.defect_events_avaible = [
						DefectEvent.new('sickness_cell_container', 25),
						DefectEvent.new('jolt_single_hidden_interpreter', 15),
						DefectEvent.new('jolt_all_hidden_interpreter', 15),
					]
				

				
				4 : 
					IVDefectEventManager.inital_wait_time = 30.0
					IVDefectEventManager.defect_event_trigger_wait_time = 15.0
					IVDefectEventManager.defect_events_avaible = [
						DefectEvent.new('sickness_cell_container', 25),
						DefectEvent.new('jolt_single_hidden_interpreter', 25),
						DefectEvent.new('jolt_all_hidden_interpreter', 25),
					]
		

				

	
	elif round == 2:
		pass
