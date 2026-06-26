extends Node

@warning_ignore("shadowed_global_identifier")
func _update_hidden_stat_values(round : int , energy : int) :
	
	
	if round == 1 :	
		pass
	
	elif round == 2 :
		pass
	
	elif round == 3 :
		pass
	
	elif round == 4 : 
		pass
	
	var danger_level = get_energy_danger_level(energy)		
	update_hidden_stat_nax(round, danger_level)
		

func get_energy_danger_level(energy : int) -> int:
	# high energy = safer
	# low energy = more dangerous
	
	var max_energy = GLGameManagerBus.max_energy

	if energy > max_energy * 0.75:
		return 0
	elif energy > max_energy * 0.5:
		return 1
	elif energy > max_energy * .25:
		return 2
	else:
		return 3
	
@warning_ignore("shadowed_global_identifier")
func update_hidden_stat_nax(round : int, danger_level : int) :
	
	if round == 1 :	
		match danger_level :
			0 : 
				pass
			1 : 
				pass
			2 : 
				pass
			3 : 
				pass
	
	elif round == 2 :
		match danger_level :
			0 : 
				pass
			1 : 
				pass
			2 : 
				pass
			3 : 
				pass
	
	elif round == 3 : 	
		match danger_level :
			0 : 
				pass
			1 : 
				pass
			3 : 
				pass
	
	elif round == 4 :
		match danger_level :
			0 : 
				pass
			1 : 
				pass
			2 : 
				pass
			3 : 
				pass
	
	
	
	
	
	
	
