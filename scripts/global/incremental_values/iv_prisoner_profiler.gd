extends Node

# stat increment
var stat_increment_amount : int = 20
var per_stat_increment_energy_decrease : int = 2

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

# spare symbols
var spare_symbol_minimum_created = 2
var spare_symbol_max_created = 2
var spare_symbols_avaible = [
	{'defect' : ['up', 'down']}	,
	{'good_mutation' : ['up', 'down']},
	{'bad_mutation' : ['up', 'down']},
	{'energy' : ['up', 'down']},
]
