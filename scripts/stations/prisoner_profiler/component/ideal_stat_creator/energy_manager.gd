extends Node

# components
@onready var parent_ideal_stat_creator : Node = $".."


var ideal_stat_energy_spent : Dictionary[String, int] = {
	'strength' : 0, 
	'intelligence' : 0,
	'community' : 0,
}


func _initate_new_energy_state() : 
	ideal_stat_energy_spent['strength'] = 0
	ideal_stat_energy_spent['intelligence'] = 0
	ideal_stat_energy_spent['community'] = 0
	
	compute_max_energy()
	
func compute_max_energy() :
	
	# start at 3, because index starts at 0 
	var total_lock_index : int = 3
	
	total_lock_index += IVPrisonerProfiler.strength_stat_lock_percant_index
	total_lock_index += IVPrisonerProfiler.intelligence_stat_lock_percant_index
	total_lock_index += IVPrisonerProfiler.community_stat_lock_percant_index
	
	var max_energy : int = 0
	
	var curr_index = 0 
	
	while curr_index != total_lock_index : 
		
		# increase max energy with reach lock index
		max_energy += IVPrisonerProfiler.per_lock_index_energy_increase
		
		curr_index += 1	
	
	parent_ideal_stat_creator.total_energy = max_energy
	
func _compute_energy_state() -> void:
	
	var ideal_stats: Array[IdealStat] = parent_ideal_stat_creator.get_ideal_stats()

	for ideal_stat in ideal_stats:
		var stat_type: String = ideal_stat.stat_type

		if not ideal_stat.enabled:
			ideal_stat_energy_spent[stat_type] = 5
		else:
			ideal_stat_energy_spent[stat_type] = (
				-ideal_stat.increments_used
				* IVPrisonerProfiler.per_stat_increment_energy_decrease
			)

func _get_total_energy_spent() -> int:
	var total_energy_spent: int = 0 

	for stat_type: String in ideal_stat_energy_spent:
		total_energy_spent += ideal_stat_energy_spent[stat_type]

	return total_energy_spent
	
