extends Node

func _handle_prisoner_pricks(cell_quantity : int) :
	
	var ran_num = randi_range(0, 100)	
	
	
	if cell_quantity == 2 :
		if ran_num <= 25 : 
			GLPrisonerPicks.prisoners_to_pick = 1 
		else : 
			GLPrisonerPicks.prisoners_to_pick = 2
	
	elif cell_quantity == 4 : 
		GLPrisonerPicks.prisoners_to_pick = 2
	
	
