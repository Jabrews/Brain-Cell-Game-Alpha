extends Node

@warning_ignore("shadowed_global_identifier")
func _update_workstations_core(round: int, goal_piece: int) -> void:
	
	if round == 1:
		pass
	
	update_workstations_core(round, goal_piece)


@warning_ignore("shadowed_global_identifier")
func update_workstations_core(round: int, goal_piece: int) -> void:
	
	if round == 1:
		match goal_piece :
			1 :
				# breeder
				GLWorkstationBus.breeder_enabled = true 
				# attacher
				GLWorkstationBus.attacher_enabled = true 
				GLWorkstationBus.attacher_failure_enabled = true 
				# detacher
				GLWorkstationBus.detacher_enabled = true
				GLWorkstationBus.detacher_failure_enabled = true
			2 : 
				GLWorkstationBus.breeder_enabled = true 
				GLWorkstationBus.attacher_enabled = true 
				GLWorkstationBus.detacher_enabled = true 
				GLWorkstationBus.attacher_failure_enabled = true 
				GLWorkstationBus.detacher_failure_enabled = true 
