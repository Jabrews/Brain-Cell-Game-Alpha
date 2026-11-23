extends Node


@warning_ignore("shadowed_global_identifier")
func _update_cell_stat_creation(round: int, goal_piece: int) -> void:
	
	if round == 1:
		pass
	
	update_cell_stat_values(round, goal_piece)


@warning_ignore("shadowed_global_identifier")
func update_cell_stat_values(round: int, goal_piece: int) -> void:
	
	if round == 1:
		match goal_piece:
			1:
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
			
			2:
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
			
			3:
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
			
			4:
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
	
	elif round == 2:
		pass
