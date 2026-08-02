extends Node

@warning_ignore("shadowed_global_identifier")
func _update_hidden_stat_values(round : int , energy : int) :
	
	
	if round == 1 :	
		IVHiddenStats.stats_to_hide = []
		IVHiddenStats.max_time_to_discover_hidden = 40
	
	elif round == 2 :
		IVHiddenStats.stats_to_hide = ['strength']
		IVHiddenStats.max_time_to_discover_hidden = 40
	
	var danger_level = get_energy_danger_level(energy)		
	update_hidden_stat_nax(round, danger_level)
		

func get_energy_danger_level(energy: int) -> int:
	# 75%–100% = 0
	# 50%–75%  = 1
	# 25%–50%  = 2
	# 0%–25%   = 3

	var max_energy: int = GLGameManagerBus.max_energy
	var energy_percent: float = float(energy) / float(max_energy)

	if energy_percent >= 0.75:
		return 0
	elif energy_percent >= 0.50:
		return 1
	elif energy_percent >= 0.25:
		return 2
	else:
		return 3
	
@warning_ignore("shadowed_global_identifier")
func update_hidden_stat_nax(round : int, danger_level : int) :
	
	if round == 1 :	
		match danger_level :
			0 : 
				IVHiddenStats.max_stats_to_hide = 2
			1 : 
				IVHiddenStats.max_stats_to_hide = 3
			2 : 
				IVHiddenStats.max_stats_to_hide = 4
				IVHiddenStats.stats_to_hide = ['strength']
			3 : 
				IVHiddenStats.max_stats_to_hide = 5
				IVHiddenStats.stats_to_hide = ['strength', 'intelligence']
	
	elif round == 2 :
		match danger_level :
			0 : 
				IVHiddenStats.max_stats_to_hide = 3
				IVHiddenStats.stats_to_hide = ['strength']
			1 : 
				IVHiddenStats.max_stats_to_hide = 5
				IVHiddenStats.stats_to_hide = ['strength', 'intelligence']
			2 : 
				IVHiddenStats.max_stats_to_hide = 6
				IVHiddenStats.stats_to_hide = ['strength', 'intelligence', 'community']
			3 : 
				IVHiddenStats.max_stats_to_hide = 7
				IVHiddenStats.stats_to_hide = ['strength', 'intelligence', 'community']
