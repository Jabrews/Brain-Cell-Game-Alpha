extends Node

@warning_ignore("shadowed_global_identifier")
func _update_cell_stat_creation(round : int , energy : int) :
	
	if round == 1 :
		IVCellCreator.chance_of_bad_stats = 25
		IVCellCreator.chance_of_no_defect = 50
	
	elif round == 2 :
		IVCellCreator.chance_of_bad_stats = 30
		IVCellCreator.chance_of_no_defect = 35
		
	elif round == 3 :
		IVCellCreator.chance_of_bad_stats = 40
		IVCellCreator.chance_of_no_defect = 25
		
	elif round == 4 :
		IVCellCreator.chance_of_bad_stats = 50
		IVCellCreator.chance_of_no_defect = 15
	
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
				IVCellCreator.clean_stat_addition_min = 5
				IVCellCreator.clean_stat_addition_max = 10
				IVCellCreator.defect_stat_addition_min = 0
				IVCellCreator.defect_stat_addition_max = 5
			1 :
				IVCellCreator.clean_stat_addition_min = 5
				IVCellCreator.clean_stat_addition_max = 12
				IVCellCreator.defect_stat_addition_min = 0
				IVCellCreator.defect_stat_addition_max = 7
			2 :
				IVCellCreator.clean_stat_addition_min = 5
				IVCellCreator.clean_stat_addition_max = 12
				IVCellCreator.defect_stat_addition_min = 2
				IVCellCreator.defect_stat_addition_max = 7
			3 :
				IVCellCreator.clean_stat_addition_min = 6
				IVCellCreator.clean_stat_addition_max = 15
				IVCellCreator.defect_stat_addition_min = 2
				IVCellCreator.defect_stat_addition_max = 10
	
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
				IVCellCreator.defect_stat_addition_max = 112
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
	
	elif round == 3 :
		match danger_level :
			0 :
				pass
	
			1 :
				pass
	
			2 :
				pass
	
			3 :
				pass
	
	
	elif round == 4 :
		match danger_level :
			0 :
				pass
	
			1 :
				pass
	
			2 :
				pass
	
			3 :
				pass
	
	
	
	
	
	
	
