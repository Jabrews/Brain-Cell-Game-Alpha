extends Node


func _update(interpreter_chance: int, cell_chance: int, applied_interpreter_weight: bool ):
	
	if not GameAdminPanel.enabled:
		return
	
	# Clear the current defect event record before recording
	# the new state.
	GameAdminPanel.updater_defect_event.defect_event_base.clear()
	
	
	# NONE
	GameAdminPanel.updater_defect_event.defect_event_base.append(
		DefectEventBase.new(
			"none",
			IVDefectEventManager.no_event_chance,
			false,
			""
		)
	)
	
	# INTERPRETER
	var interpreter_explanation: String = ""

	if applied_interpreter_weight:
		interpreter_explanation = (
			"Chance increased by 20% because an interpreter had a cell on it"
		)
	
	GameAdminPanel.updater_defect_event.defect_event_base.append(
		DefectEventBase.new(
			"interpreter",
			interpreter_chance,
			applied_interpreter_weight,
			interpreter_explanation
		)
	)
	
	
	# CELL
	GameAdminPanel.updater_defect_event.defect_event_base.append(
		DefectEventBase.new(
			"cell",
			cell_chance,
			false,
			'',	
		)
	)
