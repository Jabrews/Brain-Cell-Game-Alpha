extends Node


@warning_ignore("shadowed_global_identifier")
func _update_defect_event_values(round: int, energy: int) -> void:
	var danger_level := get_energy_danger_level(energy)

	match round:
		1:
			IVDefectEventManager.max_defect_event_update_timer_duration = 40
			IVDefectEventManager.interpreter_jolt_energy_decrease_single = 2
			IVDefectEventManager.interpreter_jolt_energy_decrease_multiple = 1
			IVDefectEventManager.no_event_chance = 50
			IVDefectEventManager.jolt_cell_container_chance = 25
			IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 25
			IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt = 50
			IVDefectEventManager.interpreter_jolt_defect_increase = 20
			IVDefectEventManager.cell_container_jolt_defect_increase = 20

			match danger_level:
				0:
					pass
				1:
					pass
				2:
					pass
				3:
					pass


		2:
			IVDefectEventManager.max_defect_event_update_timer_duration = 40
			IVDefectEventManager.interpreter_jolt_energy_decrease_single = 2
			IVDefectEventManager.interpreter_jolt_energy_decrease_multiple = 1
			IVDefectEventManager.no_event_chance = 50
			IVDefectEventManager.jolt_cell_container_chance = 25
			IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 25
			IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt = 50
			IVDefectEventManager.interpreter_jolt_defect_increase = 20
			IVDefectEventManager.cell_container_jolt_defect_increase = 20

			match danger_level:
				0:
					pass
				1:
					pass
				2:
					pass
				3:
					pass


func get_energy_danger_level(energy: int) -> int:
	var max_energy: int = GLGameManagerBus.max_energy
	var energy_percent: float = float(energy) / float(max_energy)

	if energy_percent >= 0.75:
		return 0
	elif energy_percent >= 0.50:
		return 1
	elif energy_percent >= 0.25:
		return 2
	else:
		return 3
