extends Node

# componnets
@onready var handle_energy : Node = $".."


func _get_energy(stat_type : String) -> int : 
	match stat_type :
		'strength' :
			return handle_energy.stat_value_energy_used['strength']
		'intelligence' :
			return handle_energy.stat_value_energy_used['intelligence']
		'community' : 
			return handle_energy.stat_value_energy_used['community']
		_ :
			return 0
