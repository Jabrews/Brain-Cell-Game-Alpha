extends Node

func _create(stat: BrainCellStat, stat_cap_status : String) -> float:
	
	# if disabled no defect value	
	if stat.enabled == false :
		return 0.0
		
	var stat_value = generate_random_stat_value(stat.value)
	
	stat_value = detect_and_apply_stap_cap(stat_value, stat_cap_status)
	
	return stat_value

func generate_random_stat_value(stat_base: float) :
	
	var random_1 = stat_base + 6
	var random_2 = stat_base - 6
	var random_3 = stat_base + 8
	var random_4 = stat_base - 8
	var random_5 = stat_base + 12
	var random_6 = stat_base - 12
	var random_7 = stat_base - 15
	var random_8 = stat_base - 20
	var random_9 = stat_base - 22
	
	var random_diffrence_array = [random_1, random_2, random_3, random_4, random_5, random_6, random_7, random_8, random_9]
	stat_base = random_diffrence_array.pick_random()
	
	return stat_base

func detect_and_apply_stap_cap(stat_value : float, stat_cap_status : String):
	
	if stat_cap_status == "none":
		return stat_value

	else:
		push_error("invalid stat cap: %s" % stat_cap_status)
		return stat_value

	
