extends Node


@warning_ignore("shadowed_global_identifier")
func _update_hidden_stat_values(round: int, goal_piece: int) -> void:
	
	if round == 1:
		IVHiddenStats.max_time_to_discover_hidden = 10
	
	update_hidden_stat_max(round, goal_piece)


@warning_ignore("shadowed_global_identifier")
func update_hidden_stat_max(round: int, goal_piece: int) -> void:
	
	if round == 1:
		match goal_piece:
			1:
				IVHiddenStats.max_stats_to_hide = 3
				IVHiddenStats.stats_to_hide = ["strength"]
				IVHiddenStats.total_possible_hidden_bombs = 1
			
			2:
				IVHiddenStats.max_stats_to_hide = 4
				IVHiddenStats.stats_to_hide = ["strength", "intelligence"]
				IVHiddenStats.total_possible_hidden_bombs = 2
			
			3:
				IVHiddenStats.max_stats_to_hide = 5
				IVHiddenStats.stats_to_hide = ["strength", "intelligence", "community"]
				IVHiddenStats.total_possible_hidden_bombs = 3
			
			4:
				IVHiddenStats.max_stats_to_hide = 6
				IVHiddenStats.stats_to_hide = ["strength", "intelligence", "community"]
				IVHiddenStats.total_possible_hidden_bombs = 4
	
	elif round == 2:
		pass
