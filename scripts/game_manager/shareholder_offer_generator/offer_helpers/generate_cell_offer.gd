extends Node

func _generate_demand_cell() -> BrainCell:
	var strength_value: float = get_stat_value('strength')
	var intelligence_value: float = get_stat_value('intelligence')
	var community_value: float = get_stat_value('community')
	
	var MAX_DISABLED_STATS: int = IVShareholderOffers.non_enabled_stats_max
	
	var stat_types: Array[String] = [
		"strength",
		"intelligence",
		"community"
	]
	
	stat_types.shuffle()
	
	var disabled_amount: int = clamp(MAX_DISABLED_STATS, 0, stat_types.size())
	var disabled_stats: Array[String] = []
	
	for i in range(disabled_amount):
		disabled_stats.append(stat_types[i])
	
	var strength_enabled: bool = not disabled_stats.has("strength")
	var intelligence_enabled: bool = not disabled_stats.has("intelligence")
	var community_enabled: bool = not disabled_stats.has("community")
	
	var strength_stat := BrainCellStat.new(
		"strength",
		strength_enabled,
		strength_value,
		0.0,
		false
	)
	
	var intelligence_stat := BrainCellStat.new(
		"intelligence",
		intelligence_enabled,
		intelligence_value,
		0.0,
		false
	)
	
	var community_stat := BrainCellStat.new(
		"community",
		community_enabled,
		community_value,
		0.0,
		false
	)
	
	var demand_cell := BrainCell.new(
		"demand_cell",
		[],
		strength_stat,
		intelligence_stat,
		community_stat,
		false
	)
	
	return demand_cell

func get_stat_value(stat_type : String) -> float :
	
	var lock_index : int =0
	
	match stat_type : 
		'strength' :
			lock_index = IVPrisonerProfiler.strength_stat_lock_percant_index
		'intelligence' :
			lock_index = IVPrisonerProfiler.intelligence_stat_lock_percant_index
		'community' :
			lock_index = IVPrisonerProfiler.community_stat_lock_percant_index
			
	var lock_percant = IVPrisonerProfiler.stat_lock_percantages[lock_index]
	
	var max_value = (IVCellCreator.max_stat_value * lock_percant) + 20
	
	# dont let it surpass max
	if max_value > IVCellCreator.max_stat_value: 
		max_value = IVCellCreator.max_stat_value	
		
	var stat_value = randi_range(20, max_value)
	
	return stat_value 
		
		
	
	
	
	
	
	
	
	
	
	
