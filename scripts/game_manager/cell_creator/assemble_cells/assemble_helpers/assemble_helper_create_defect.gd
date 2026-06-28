extends Node

func _create(stat: BrainCellStat, spare_symbol : StatSpareSymbol) -> float:
	
	# if disabled no defect value	
	if stat.enabled == false :
		return 0.0
		
	# possible no defect	
	var ran_num  = randi_range(0, 100)
	if ran_num <= IVCellCreator.chance_of_no_defect : 
		return 0.0
		
	var stat_value = generate_random_stat_value(stat.value)
	
	stat_value = apply_spare_symbol(stat_value, spare_symbol)
	
	stat_value = clamp(stat_value, 1, IVCellCreator.max_stat_value) 
	stat_value = round(stat_value* 10.0) / 10.0
	
	return stat_value

func generate_random_stat_value(stat_base: float) :
	
	var random_diffrence_num: int
	
	var ran_num := randi_range(1, 100)
	
	# Bad defect roll: defect goes UP
	if ran_num <= IVCellCreator.chance_of_bad_stats:
		random_diffrence_num = randi_range(
			IVCellCreator.defect_stat_addition_min,
			IVCellCreator.defect_stat_addition_max
		)
	
	# Good defect roll: defect goes DOWN
	else:
		random_diffrence_num = randi_range(
			-IVCellCreator.defect_stat_addition_max,
			-IVCellCreator.defect_stat_addition_min
		)
	
	stat_base += random_diffrence_num
	
	return stat_base

func apply_spare_symbol(stat_value : float, spare_symbol : StatSpareSymbol):
	
	if spare_symbol.type == "none":
		return stat_value
	
	if spare_symbol.type == 'defect' :
		
		if spare_symbol.direction == 'up' :		
			stat_value += randi_range(30, 50)
		elif spare_symbol.direction == 'down' :
			stat_value -= randi_range(30, 50)
		else :
			push_error('direction not found for spare symbol : ', spare_symbol)
			
		return stat_value

	else:
		return stat_value

	
