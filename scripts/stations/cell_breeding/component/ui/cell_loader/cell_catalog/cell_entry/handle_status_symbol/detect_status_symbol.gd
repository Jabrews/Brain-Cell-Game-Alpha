extends Node

func _detect(cell : BrainCell) -> Array[String] : 
	
	var found_status_symbols : Array[String] = []
	
	if detect_near_death(cell) : 	
		found_status_symbols.append('near_death_alert')
	
	if detect_low_lifespan(cell) : 
		found_status_symbols.append('low_lifespan')
		
	if detect_on_goal_interface(cell) : 
		found_status_symbols.append('on_goal_interface')
	
	if detect_breeder_unavaible(cell) : 
		found_status_symbols.append('breeder_unavailable')
	
	return found_status_symbols
	
		



	
func detect_near_death(cell : BrainCell) -> bool :
	var near_death_chance : float = GAMECellBreeder.death_chance_helper._get_total_death_chance(cell, false)
	return near_death_chance >= 50.0

func detect_low_lifespan(cell : BrainCell) -> bool : 
	return cell.life_span == 1
	
func detect_on_goal_interface(cell : BrainCell) -> bool : 
	
	for panel_name : String in GLGoalThresholdBus.dissolving_cells_on_goal_threshold_panel : 
		if panel_name == cell.name : 
			return true
	
	return false

func detect_breeder_unavaible(cell : BrainCell) -> bool : 
	return cell.breeder_unavaible == true
	
	
	
	
