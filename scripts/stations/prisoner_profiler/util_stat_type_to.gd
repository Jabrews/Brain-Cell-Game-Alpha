extends Node

@onready var parent_station : Node = $"../.."
	

func stat_type_to_value(stat_type : String)  -> float :
	match stat_type :
		'strength' :
			return parent_station.strength_value
		'intelligence' :
			return parent_station.intelligence_value
		'community' :
			return parent_station.community_value
		_ :
			return 0.0


func stat_type_to_enabled(stat_type : String)  -> bool:
	match stat_type :
		'strength' :
			return parent_station.strength_enabled
		'intelligence' :
			return parent_station.intelligence_enabled
		'community' :
			return parent_station.community_enabled
		_ :
			return 0.0


func stat_type_to_lock_limit(stat_type : String) -> float:
	match stat_type :
		'strength' :
			return parent_station.strength_lock_starting_value
		'intelligence' :
			return parent_station.intelligence_lock_starting_value
		'community' :
			return parent_station.community_lock_starting_value
		_ :
			return 0.0
