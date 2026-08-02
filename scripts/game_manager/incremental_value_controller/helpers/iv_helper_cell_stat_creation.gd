extends Node

@warning_ignore("shadowed_global_identifier")
func _update_cell_stat_creation(round : int , energy : int) :
	
	if round == 1 :
		IVCellCreator.chance_of_bad_stats = 40
		IVCellCreator.chance_of_no_defect = 50
		IVCellCreator.chance_to_half_defect = 60
		IVCellCreator.chance_to_half_clean = 30
	
	elif round == 2 :
		IVCellCreator.chance_of_bad_stats = 55
		IVCellCreator.chance_of_no_defect = 35
		IVCellCreator.chance_to_half_defect = 40
		IVCellCreator.chance_to_half_clean = 50
		
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
				IVCellCreator.clean_stat_addition_min = 0
				IVCellCreator.clean_stat_addition_max = 6
				IVCellCreator.defect_stat_addition_min = 1
				IVCellCreator.defect_stat_addition_max = 5

			1 :
				IVCellCreator.clean_stat_addition_min = 0
				IVCellCreator.clean_stat_addition_max = 8
				IVCellCreator.defect_stat_addition_min = 2
				IVCellCreator.defect_stat_addition_max = 7
			2 :
				IVCellCreator.clean_stat_addition_min = 1
				IVCellCreator.clean_stat_addition_max = 10
				IVCellCreator.defect_stat_addition_min = 3
				IVCellCreator.defect_stat_addition_max = 7
			3 :
				IVCellCreator.clean_stat_addition_min = 0
				IVCellCreator.clean_stat_addition_max = 11
				IVCellCreator.defect_stat_addition_min = 4
				IVCellCreator.defect_stat_addition_max = 7
	
	elif round == 2 :
		match danger_level :
			0 :
				IVCellCreator.clean_stat_addition_min = 7
				IVCellCreator.clean_stat_addition_max = 10
				IVCellCreator.defect_stat_addition_min = 0
				IVCellCreator.defect_stat_addition_max = 8
			1 :
				IVCellCreator.clean_stat_addition_min = 7
				IVCellCreator.clean_stat_addition_max = 12
				IVCellCreator.defect_stat_addition_min = 0
				IVCellCreator.defect_stat_addition_max = 12
			2 :
				IVCellCreator.clean_stat_addition_min = 5
				IVCellCreator.clean_stat_addition_max = 15
				IVCellCreator.defect_stat_addition_min = 2
				IVCellCreator.defect_stat_addition_max = 15
			3 :
				IVCellCreator.clean_stat_addition_min = 5
				IVCellCreator.clean_stat_addition_max = 15
				IVCellCreator.defect_stat_addition_min = 5
				IVCellCreator.defect_stat_addition_max = 10
	
	
	
	
	
	
	
	
