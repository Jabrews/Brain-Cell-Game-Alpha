extends Node

@warning_ignore("shadowed_global_identifier")
func _update_cell_stat_creation(round : int , energy : int) :
	
	if round == 1 :
		pass
		
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
				
				IVCellCreator.chance_of_bad_stats = 20
				IVCellCreator.chance_of_no_defect = 75
				IVCellCreator.chance_to_half_defect = 1
				IVCellCreator.chance_to_half_clean = 1
				IVCellCreator.chance_of_extreme_defect = 10
				
				# additions min and max 
				IVCellCreator.clean_stat_addition_min = 7
				IVCellCreator.clean_stat_addition_max = 10
				IVCellCreator.defect_stat_addition_min = 0
				IVCellCreator.defect_stat_addition_max = 8
			1 :
				
				IVCellCreator.chance_of_bad_stats = 35
				IVCellCreator.chance_of_no_defect = 25
				IVCellCreator.chance_to_half_defect = 25
				IVCellCreator.chance_to_half_clean = 15
				IVCellCreator.chance_of_extreme_defect = 20
				
				# additions min and max 
				IVCellCreator.clean_stat_addition_min = 7
				IVCellCreator.clean_stat_addition_max = 12
				IVCellCreator.defect_stat_addition_min = 0
				IVCellCreator.defect_stat_addition_max = 12
			2 :
				
				IVCellCreator.chance_of_bad_stats = 55
				IVCellCreator.chance_of_no_defect = 15
				IVCellCreator.chance_to_half_defect = 15
				IVCellCreator.chance_to_half_clean = 20
				IVCellCreator.chance_of_extreme_defect = 25
				
				# additions min and max 
				IVCellCreator.clean_stat_addition_min = 5
				IVCellCreator.clean_stat_addition_max = 15
				IVCellCreator.defect_stat_addition_min = 2
				IVCellCreator.defect_stat_addition_max = 15
			3 :
				
				IVCellCreator.chance_of_bad_stats = 60
				IVCellCreator.chance_of_no_defect = 5
				IVCellCreator.chance_to_half_defect = 10
				IVCellCreator.chance_to_half_clean = 25
				IVCellCreator.chance_of_extreme_defect = 30
				
				# additions min and max 
				IVCellCreator.clean_stat_addition_min = 5
				IVCellCreator.clean_stat_addition_max = 15
				IVCellCreator.defect_stat_addition_min = 5
				IVCellCreator.defect_stat_addition_max = 10
	
	elif round == 2 :
		pass

	
	
	
	
	
	
	
	
