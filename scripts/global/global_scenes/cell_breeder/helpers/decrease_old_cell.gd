extends Node

func _decrease(cell : BrainCell) -> BrainCell :
	
	
	cell.strength.defect += IVCellCreator.max_stat_value * 0.15
	cell.intelligence.defect += IVCellCreator.max_stat_value * 0.15
	cell.community.defect += IVCellCreator.max_stat_value * 0.15
	
	return cell
	
func _get_increased_defect_stat(stat_value) -> float : 
	return stat_value + IVCellCreator.max_stat_value * 0.15
	
	
