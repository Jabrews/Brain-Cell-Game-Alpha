extends Node

# helper componentns
@onready var decrease_old_cell : Node = $DecreaseOldCell

@export var life_span_increase: Dictionary[int, float] = {
	4 : 0,
	3 : 0,
	2 : 5.0,
	1 : 15.0,
	0 : 20.0,
}

@export var defect_percant_increase : Dictionary[int, float] = {
	1 : 15.0,
	2 : 25.0,
}

func _get_total_death_chance(cell : BrainCell, allow_hidden_stat : bool) -> float: 
	
	var death_chance : float = 0.0	
	
	# lifespan
	death_chance = evaluate_lifespan(cell.life_span)	
	
	# defect 
	for stat : BrainCellStat in [cell.strength, cell.intelligence, cell.community]:
		if not stat.hidden or allow_hidden_stat:
			
			if not stat.enabled : 
				death_chance += 0.0
			else : 
				death_chance += evluate_defect(stat.defect)			
	
	death_chance = clamp(death_chance, 0, 100)
	
	return death_chance
	

func evaluate_lifespan(life_span : int) -> float :
	var chance_increase = life_span_increase.get(life_span)
	
	return chance_increase
	
	
func evluate_defect(defect: float) -> float:
	var max_stat: float = IVCellCreator.max_stat_value
	
	var defect_percent: float = (defect / max_stat) * 100
	
	var chance_increase: float = 0.0
	
	# 50% - 75% defect
	if defect_percent >= 50.0 and defect_percent < 75.0:
		chance_increase = defect_percant_increase.get(1)
	
	# 75%+ defect
	elif defect_percent >= 75.0:
		chance_increase = defect_percant_increase.get(2)
	
	return chance_increase
	
	
	
	
	
	
	
	
	
