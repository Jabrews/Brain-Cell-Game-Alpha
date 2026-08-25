extends Node


var current_defect_urgency_num: int = 0


func _ready() -> void:
	GLGameManagerBus.connect('process_next_round', _handle_process_next_round)
	GLDefectEventMangerBus.connect('cell_added_to_trashcan', _handle_cell_added_to_trashcan)
	GLDefectEventMangerBus.connect('prisoners_extracted', _handle_prisoners_extracted)
	
	update_defect_event_chance()
	

func _handle_process_next_round() -> void:
	IVDefectEventManager.current_defect_urgency_num = 0
	update_defect_event_chance()


func _handle_cell_added_to_trashcan() -> void:
	IVDefectEventManager.current_defect_urgency_num += 1
	update_defect_event_chance()


func _handle_prisoners_extracted(quantity: int) -> void:
	IVDefectEventManager.current_defect_urgency_num += quantity
	update_defect_event_chance()


func get_defect_urgency_phase(defect_urgency_num: int) -> int:
	
	var trashcan_max_capacity: int = IVCellTrashcan.max_capaicty
	
	var urgency_percent: float = (
		float(defect_urgency_num) / float(trashcan_max_capacity)
	)
	
	if urgency_percent >= 1.0:
		return 3
	elif urgency_percent >= 0.5:
		return 2
	else:
		return 1

func update_defect_event_chance() -> void:
	
	var urgency_phase: int = get_defect_urgency_phase(
		IVDefectEventManager.current_defect_urgency_num
	)
	
	match GLGameManagerBus.current_round:
		1:
			match urgency_phase:
				1:
					# CHANCES
					IVDefectEventManager.no_event_chance = 50 # BASE
					
					IVDefectEventManager.cell_container_event_chance = 75 # BASE
					IVDefectEventManager.container_bubble_chance = 0
					IVDefectEventManager.container_sickness_chance = 100
					
					IVDefectEventManager.jolt_interpreter_chance = 25 # BASE
					IVDefectEventManager.jolt_all_interpreter_chance = 0
					# INTERPRETER ENERGY
					IVDefectEventManager.interpreter_jolt_energy_decrease_single = 1
					IVDefectEventManager.interpreter_jolt_energy_decrease_multiple = 1
					
					# WAIT TIME
					IVDefectEventManager.defect_event_trigger_wait_time = 20.0
				
				2:
					# CHANCES
					IVDefectEventManager.no_event_chance = 30 # BASE
					
					IVDefectEventManager.cell_container_event_chance = 25 # BASE
					IVDefectEventManager.container_bubble_chance = 75
					IVDefectEventManager.container_sickness_chance = 25
					
					IVDefectEventManager.jolt_interpreter_chance = 75 # BASE
					IVDefectEventManager.jolt_all_interpreter_chance = 20
					# INTERPRETER ENERGY
					IVDefectEventManager.interpreter_jolt_energy_decrease_single = 1
					IVDefectEventManager.interpreter_jolt_energy_decrease_multiple = 1
					
					# WAIT TIME
					IVDefectEventManager.defect_event_trigger_wait_time = 20.0
				
				3:
					# CHANCES
					IVDefectEventManager.no_event_chance = 25 # BASE
					
					IVDefectEventManager.cell_container_event_chance = 50 # BASE
					IVDefectEventManager.container_bubble_chance = 50
					IVDefectEventManager.container_sickness_chance = 50
					
					IVDefectEventManager.jolt_interpreter_chance = 50 # BASE
					IVDefectEventManager.jolt_all_interpreter_chance = 35
					# INTERPRETER ENERGY
					IVDefectEventManager.interpreter_jolt_energy_decrease_single = 1
					IVDefectEventManager.interpreter_jolt_energy_decrease_multiple = 1
					
					# WAIT TIME
					IVDefectEventManager.defect_event_trigger_wait_time = 15.0
				
