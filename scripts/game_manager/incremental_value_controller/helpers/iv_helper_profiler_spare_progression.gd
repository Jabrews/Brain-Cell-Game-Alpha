extends Node

@warning_ignore("shadowed_global_identifier")
func _update_spare_progression(round : int , energy : int) :
	
	
	if round == 1 :	
		IVPrisonerProfiler.spare_symbols_avaible = [
			{'defect' : ['up', 'down']}	,
			#{'good_mutation' : ['up', 'down']},
			#{'bad_mutation' : ['up', 'down']},
			#{'energy' : ['up', 'down']},
			{'energy' : ['up']},
			
		]
		
	
	elif round == 2 :
		IVPrisonerProfiler.spare_symbols_avaible = [
			{'defect' : ['up', 'down']}	,
			#{'good_mutation' : ['up', 'down']},
			#{'bad_mutation' : ['up', 'down']},
			{'energy' : ['up', 'down']},
		]
		
	elif round == 3 :
		IVPrisonerProfiler.spare_symbols_avaible = [
			{'defect' : ['up', 'down']}	,
			{'good_mutation' : ['up', 'down']},
			#{'bad_mutation' : ['up', 'down']},
			{'energy' : ['up', 'down']},
		]
	
	elif round == 4 : 
		IVPrisonerProfiler.spare_symbols_avaible = [
			{'defect' : ['up', 'down']}	,
			{'good_mutation' : ['up', 'down']},
			{'bad_mutation' : ['up', 'down']},
			{'energy' : ['up', 'down']},
		]
	
	var danger_level = get_energy_danger_level(energy)		
	update_hidden_stat_nax(round, danger_level)
		

func get_energy_danger_level(energy : int) -> int:
	# high energy = safer
	# low energy = more dangerous
	
	var max_energy = GLGameManagerBus.max_energy

	if energy > max_energy * 0.75:
		return 0
	elif energy > max_energy * 0.5:
		return 1
	elif energy > max_energy * .25:
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
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 2
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 4
			1 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 0
				IVPrisonerProfiler.spare_symbol_max_created = 1
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 2
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 4			
			2 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 1
				IVPrisonerProfiler.spare_symbol_max_created = 1
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 3
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 5
			3 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 1
				IVPrisonerProfiler.spare_symbol_max_created = 1
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 4
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 5
	
	elif round == 2 :
		match danger_level :
			0 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 0
				IVPrisonerProfiler.spare_symbol_max_created = 1
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 3
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 5
			1 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 0
				IVPrisonerProfiler.spare_symbol_max_created = 1
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 4
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 5
			2 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 1
				IVPrisonerProfiler.spare_symbol_max_created = 1
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 5
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 6
			3 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 2
				IVPrisonerProfiler.spare_symbol_max_created = 2
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 5
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 6
	
	elif round == 3 : 	
		match danger_level :
			0 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 1
				IVPrisonerProfiler.spare_symbol_max_created = 2
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 5
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 7
			1 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 1
				IVPrisonerProfiler.spare_symbol_max_created = 2
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 6
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 7
			2 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 2
				IVPrisonerProfiler.spare_symbol_max_created = 2
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 6
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 7
			3 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 3
				IVPrisonerProfiler.spare_symbol_max_created = 3
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 6
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 7
	
	elif round == 4 :
		match danger_level :
			0 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 2
				IVPrisonerProfiler.spare_symbol_max_created = 2
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 4
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 6
			1 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 2
				IVPrisonerProfiler.spare_symbol_max_created = 2
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 5
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 6
			2 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 3
				IVPrisonerProfiler.spare_symbol_max_created = 3
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 6
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 7
			3 : 
				IVPrisonerProfiler.spare_symbol_minimum_created = 3
				IVPrisonerProfiler.spare_symbol_max_created = 3
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min = 6
				IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max = 7
	
	
	
	
	
	
	
