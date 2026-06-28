extends Node

func _create(stat_constructor : StatConstructor) -> BrainCellStat :
	
	# if stat is disabled return null	
	if stat_constructor.stat_enabled == false:
		return BrainCellStat.new(
			stat_constructor.stat_type,
			false,
			0.0,
			0.0,
			false,
		)
	
	var stat_value = generate_random_stat_value(stat_constructor.stat_base_clean_value)
	
	stat_value = apply_spare_symbol(stat_value, stat_constructor.spare_symbol)
	
	stat_value = clamp(stat_value, 1, IVCellCreator.max_stat_value) 
	stat_value = round(stat_value* 10.0) / 10.0
	
	return BrainCellStat.new(
		stat_constructor.stat_type,
		true,
		stat_value,
		0.0,
		false,
	)
	

func generate_random_stat_value(stat_base: float) :
	
	var random_diffrence_num : int
	
	# chance to get negtive num	
	var ran_num = randi_range(0, 100)
	if ran_num <= IVCellCreator.chance_of_bad_stats :
		random_diffrence_num = randi_range( -IVCellCreator.clean_stat_addition_max, -IVCellCreator.clean_stat_addition_min)	
	else :
		random_diffrence_num = randi_range(IVCellCreator.clean_stat_addition_min, IVCellCreator.clean_stat_addition_max)
		
	stat_base += random_diffrence_num
	
	return stat_base

func apply_spare_symbol(stat_value : float, spare_symbol : StatSpareSymbol ) -> float:

	if spare_symbol.type == "none":
		return stat_value

	else:
		return stat_value
