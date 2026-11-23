extends Node

@warning_ignore("shadowed_global_identifier")
func _update_creation_methods(round: int, goal_piece: int) -> void:
	
	if round == 1:
		pass
	
	update_creation_method(round, goal_piece)


@warning_ignore("shadowed_global_identifier")
func update_creation_method(round: int, goal_piece: int) -> void:
	
	if round == 1:
		match goal_piece :
			1 :
				
				## DEFAULT CREATE	
				IVDefaultPrisonerCreate.equal_defect_weight_under_50 = 0.9
				IVDefaultPrisonerCreate.above_defect_weight_under_50 = 0.1 
				
				IVDefaultPrisonerCreate.equal_defect_weight_50_to_under_75 = 0.7
				IVDefaultPrisonerCreate.above_defect_weight_50_to_under_75 = 0.3
				
				IVDefaultPrisonerCreate.equal_defect_weight_75_and_above = 0.5
				IVDefaultPrisonerCreate.above_defect_weight_75_and_above = 0.5
				
				
			2 : 
				pass
			3 : 
				## DEFAULT CREATE	
				IVDefaultPrisonerCreate.equal_defect_weight_under_50 = 0.8
				IVDefaultPrisonerCreate.above_defect_weight_under_50 = 0.2
				
				IVDefaultPrisonerCreate.equal_defect_weight_50_to_under_75 = 0.6
				IVDefaultPrisonerCreate.above_defect_weight_50_to_under_75 = 0.4
				
				IVDefaultPrisonerCreate.equal_defect_weight_75_and_above = 0.4
				IVDefaultPrisonerCreate.above_defect_weight_75_and_above = 0.6
			4 : 
				pass
