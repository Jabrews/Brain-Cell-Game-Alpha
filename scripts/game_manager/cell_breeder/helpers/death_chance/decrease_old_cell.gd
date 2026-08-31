extends Node

func _decrease(cell : BrainCell) -> BrainCell :
	
	cell.life_span -= 1	 
	
	var strength_increase_percant = randf_range(0.5, 0.20)	
	var intelligence_increase_percant = randf_range(0.5, 0.20)	
	var community_increase_percant = randf_range(0.5, 0.20)	
	
	
	cell.strength.defect += IVCellCreator.max_stat_value * strength_increase_percant
	cell.intelligence.defect += IVCellCreator.max_stat_value * intelligence_increase_percant
	cell.community.defect += IVCellCreator.max_stat_value * community_increase_percant
	
	return cell
	
func _get_increased_defect_stat(stat_value) -> float : 
	return stat_value + IVCellCreator.max_stat_value * 0.15
	
	
