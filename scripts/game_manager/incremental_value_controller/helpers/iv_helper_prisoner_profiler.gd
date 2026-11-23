extends Node


@warning_ignore("shadowed_global_identifier")
func _update_prisoner_profiler(round: int, goal_piece: int) -> void:
	
	
	if round == 1:
		IVPrisonerProfiler.stat_increment_amount = 10
		IVPrisonerProfiler.stat_lock_percantages = [0.10, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1.01]
		IVPrisonerProfiler.per_stat_increment_energy_decrease = 1
		IVPrisonerProfiler.per_lock_index_energy_increase = 1
		
	elif round == 2:
		return	
	
	update_prisoner_profiler(round, goal_piece)


@warning_ignore("shadowed_global_identifier")
func update_prisoner_profiler(round: int, goal_piece: int) -> void:
	
	if round == 1:
		match goal_piece:
			1:
				IVPrisonerProfiler.strength_stat_lock_percant_index = 0
				IVPrisonerProfiler.intelligence_stat_lock_percant_index= 0
				IVPrisonerProfiler.community_stat_lock_percant_index= 0
				
				#IVPrisonerProfiler.uncreachable_min_value = 230
				IVPrisonerProfiler.uncreachable_min_value = 230
			
			2:
				IVPrisonerProfiler.strength_stat_lock_percant_index = 1
				IVPrisonerProfiler.intelligence_stat_lock_percant_index= 1
				IVPrisonerProfiler.community_stat_lock_percant_index= 1
				
				IVPrisonerProfiler.uncreachable_min_value = 260
			
			3:
				IVPrisonerProfiler.strength_stat_lock_percant_index = 2
				IVPrisonerProfiler.intelligence_stat_lock_percant_index= 2
				IVPrisonerProfiler.community_stat_lock_percant_index= 2
				
				IVPrisonerProfiler.uncreachable_min_value = 280
			
			4:
				IVPrisonerProfiler.strength_stat_lock_percant_index = 2
				IVPrisonerProfiler.intelligence_stat_lock_percant_index= 2
				IVPrisonerProfiler.community_stat_lock_percant_index= 2
				
				IVPrisonerProfiler.uncreachable_min_value = 300

	elif round == 2:
		return
