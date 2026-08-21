extends Node

@warning_ignore("shadowed_global_identifier")
func _update_spare_progression(round : int , energy : int) :
	
	
	if round == 1 :	
		IVPrisonerProfiler.spare_symbols_avaible = [
			{'defect' : ['up', 'down']}	,
			{'energy' : ['up', 'down']},
		]
		
	elif round == 2 :
		IVPrisonerProfiler.spare_symbols_avaible = [
			{'defect' : ['up', 'down']}	,
			{'energy' : ['up', 'down']},
		]
	
	var danger_level = get_energy_danger_level(energy)		
	update_hidden_stat_nax(round, danger_level)
		
func get_energy_danger_level(energy: int) -> int:
	# 75%–100% = 0
	# 50%–75%  = 1
	# 25%–50%  = 2
	# 0%–25%   = 3

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
	
@warning_ignore("shadowed_global_identifier")
func update_hidden_stat_nax(round : int, danger_level : int) :
	
	if round == 1 :	
		match danger_level :
			0 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 0
				IVPrisonerProfiler.spare_symbol_max_created = 0
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 0
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 0
			1 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 0
				IVPrisonerProfiler.spare_symbol_max_created = 0
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 0
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 0
			2 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 0
				IVPrisonerProfiler.spare_symbol_max_created = 0
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 0
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 0
			3 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 0
				IVPrisonerProfiler.spare_symbol_max_created = 0
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 0
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 0

	elif round == 2 :
		pass
