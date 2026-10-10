extends Node


@warning_ignore("shadowed_global_identifier")
func _update_spare_progression(round: int, goal_piece: int) -> void:
	
	
	if round == 1:
		return
		
	elif round == 2:
		return	
	
	update_spare_symbol_values(round, goal_piece)


@warning_ignore("shadowed_global_identifier")
func update_spare_symbol_values(round: int, goal_piece: int) -> void:
	
	if round == 1:
		match goal_piece:
			1:
				return
			
			2:
				return
			
			3:
				return
			
			4:
				return

	elif round == 2:
		return
