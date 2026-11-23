extends Node

func _handle_reduce_prisoner_picks(picks_quanity : int, max_stats_to_hide : int) :
	
	# if only one pick reduce by half
	if picks_quanity == 1:
		max_stats_to_hide = ceili(max_stats_to_hide / 2.0)
		# make sure this never goes below 1
		max_stats_to_hide = maxi(1, max_stats_to_hide)
		
	max_stats_to_hide = prevent_reducing_below_1(max_stats_to_hide)
	
	return max_stats_to_hide


			
func _handle_reduce_disabled( strength_stat_enabled : bool, intelligence_stat_enabled : bool, community_stat_enabled : bool, max_stats_to_hide : int) :
	
	if max_stats_to_hide <= 1 :
		return max_stats_to_hide
	
	if strength_stat_enabled == false :
		max_stats_to_hide -= 1
		
	if intelligence_stat_enabled == false :
		max_stats_to_hide -= 1
	
	if community_stat_enabled == false :
		max_stats_to_hide -= 1
		
	max_stats_to_hide = prevent_reducing_below_1(max_stats_to_hide)
	
	return max_stats_to_hide
	
func prevent_reducing_below_1(max_stats_to_hide : int) :
	if max_stats_to_hide <= 1 :
		return 1
	else :
		return max_stats_to_hide
	
	
	
	
	
	
	
			
		
	
	
	
