extends Node

func _decrease(cell : BrainCell) -> BrainCell :
	
	cell.life_span -= 1	 
	
	cell.strength.defect += IVCellCreator.max_stat_value * 0.25
	cell.intelligence.defect += IVCellCreator.max_stat_value * 0.25
	cell.community.defect += IVCellCreator.max_stat_value * 0.25
	
	return cell
	
func _get_increased_defect_stat(stat_value) -> float : 
	return stat_value + IVCellCreator.max_stat_value * 0.25
	
	
