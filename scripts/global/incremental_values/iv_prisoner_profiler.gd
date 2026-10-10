extends Node

# stat lock
var stat_lock_percantages : Array[float] = [
	0.25,
	0.50,
	0.75,
	1.00,
]

var strength_stat_lock_percant_index : int = 0
var intelligence_stat_lock_percant_index : int = 0
var community_stat_lock_percant_index : int = 0

# stat increment
var stat_increment_amount : int = 10
var per_stat_increment_energy_decrease : int = 1
