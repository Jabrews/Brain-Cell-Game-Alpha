extends Node

class_name OverCleanStatCase 


func over_clean_stat_case(stat_high : float, stat_low : float, target_stat : float) : 
	
	
	## evalute how far from the MAX LIMIT  the target stat is
	var target_to_max_distance = IVCellCreator.max_stat_value - target_stat
	
	## depending on that distance find hald
	var target_to_max_distance_scaled = target_to_max_distance * IVCellBreeding.over_stat_extreme_scale
	
	var over_stat_min_to_activate_random_change_mode = target_stat + target_to_max_distance_scaled
	
	var new_value : float	
	
	# min to activate random change mode
	if stat_high >= over_stat_min_to_activate_random_change_mode :
		new_value = random_change_mode(stat_high, stat_low, target_stat)
	else :
		# else we just go foward
		new_value = stat_high + stat_low / 2
		
		
	
	# round 1 decimal point
	new_value = round(new_value* 10.0) / 10.0
	
	# if finle new stat is over the max stat value. clamp to max value
	if stat_high > IVCellCreator.max_stat_value :
		stat_high = IVCellCreator.max_stat_value
	
	return new_value
	

func random_change_mode(stat_high : float, _stat_low : float, _target_stat : float) :
	
	# generate value we're subtracting
	@warning_ignore('narrowing_conversion')	
	var rand_num = randi_range(50 , stat_high)
	
	stat_high -= rand_num
	
	# round 1 decimal point
	stat_high = round(stat_high * 10.0) / 10.0
		
	# if finle new stat is over the max stat value. clamp to max value
	if stat_high > IVCellCreator.max_stat_value :
		stat_high = IVCellCreator.max_stat_valu
	
	
	return stat_high
	
	
