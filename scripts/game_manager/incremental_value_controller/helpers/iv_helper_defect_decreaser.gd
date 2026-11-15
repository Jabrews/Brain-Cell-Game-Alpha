extends Node

@warning_ignore("shadowed_global_identifier")
func _update_defect_decreaser(round: int, goal_piece: int) -> void:
	
	if round == 1:
		pass
	
	update_defect_decreaser(round, goal_piece)


@warning_ignore("shadowed_global_identifier")
func update_defect_decreaser(round: int, goal_piece: int) -> void:
	
	if round == 1:
		match goal_piece :
			1 :
				IVDefectDecreaser.cost_per_stat = 2
			2 : 
				IVDefectDecreaser.cost_per_stat = 5
