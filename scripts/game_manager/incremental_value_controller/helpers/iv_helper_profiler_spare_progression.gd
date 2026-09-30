extends Node


@warning_ignore("shadowed_global_identifier")
func _update_spare_progression(round: int, goal_piece: int) -> void:
	
	if round == 1:
		IVPrisonerProfiler.spare_symbols_avaible = [
			{"defect": ["up", "down"]},
			{"energy": ["up", "down"]},
		]
		
	elif round == 2:
		IVPrisonerProfiler.spare_symbols_avaible = [
			{"defect": ["up", "down"]},
			{"energy": ["up", "down"]},
		]
	
	update_spare_symbol_values(round, goal_piece)


@warning_ignore("shadowed_global_identifier")
func update_spare_symbol_values(round: int, goal_piece: int) -> void:
	
	if round == 1:
		match goal_piece:
			1:
				IVPrisonerProfiler.spare_symbol_minimum_created = 0
				IVPrisonerProfiler.spare_symbol_max_created = 0
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 0
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 0
			
			2:
				IVPrisonerProfiler.spare_symbol_minimum_created = 0
				IVPrisonerProfiler.spare_symbol_max_created = 0
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 0
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 0
			
			3:
				IVPrisonerProfiler.spare_symbol_minimum_created = 0
				IVPrisonerProfiler.spare_symbol_max_created = 0
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 0
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 0
			
			4:
				IVPrisonerProfiler.spare_symbol_minimum_created = 0
				IVPrisonerProfiler.spare_symbol_max_created = 0
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 0
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 0

	elif round == 2:
		pass
