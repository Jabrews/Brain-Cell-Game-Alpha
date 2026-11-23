extends RefCounted

class_name DissolvingCell


var corresponding_cell: BrainCell

var strength_dissolving_stat: DissolvingStat
var intelligence_dissolving_stat: DissolvingStat
var community_dissolving_stat: DissolvingStat

var all_stats_bonus : bool 


func _init(
	new_corresponding_cell: BrainCell,
	new_strength_dissolving_stat: DissolvingStat,
	new_intelligence_dissolving_stat: DissolvingStat,
	new_community_dissolving_stat: DissolvingStat,
	new_all_stat_bonus : bool = false,
) -> void:
	
	corresponding_cell = new_corresponding_cell
	
	strength_dissolving_stat = new_strength_dissolving_stat
	intelligence_dissolving_stat = new_intelligence_dissolving_stat
	community_dissolving_stat = new_community_dissolving_stat
	
	all_stats_bonus = new_all_stat_bonus

func get_stats() -> Array[DissolvingStat] :
	return [strength_dissolving_stat, intelligence_dissolving_stat, community_dissolving_stat]

func print_info() -> void:
	print("---- DISSOLVING CELL ----")
	print("Corresponding Cell: ", corresponding_cell)
	
	print("Strength:")
	strength_dissolving_stat.print_info()
	
	print("Intelligence:")
	intelligence_dissolving_stat.print_info()
	
	print("Community:")
	community_dissolving_stat.print_info()
	
	print("All Stat Bonus : ", all_stats_bonus)
	
	print("-------------------------")
