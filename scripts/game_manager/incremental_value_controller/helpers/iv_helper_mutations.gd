extends Node

@warning_ignore("shadowed_global_identifier")
func _update_mutations(round : int , energy : int) :
	
	if round == 1 :
		IVMutations.good_mutations= IVMutations.all_mutations
		IVMutations.bad_mutations= IVMutations.all_mutations
	
	elif round == 2 :
		IVMutations.good_mutations= IVMutations.all_mutations
		IVMutations.bad_mutations= IVMutations.all_mutations
		
	elif round == 3 :
		IVMutations.good_mutations= IVMutations.all_mutations
		IVMutations.bad_mutations= IVMutations.all_mutations
		
	elif round == 4 :
		IVMutations.good_mutations= IVMutations.all_mutations
		IVMutations.bad_mutations= IVMutations.all_mutations
	
	var danger_level = get_energy_danger_level(energy)
	update_mutation_turn(round, danger_level)
		

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
func update_mutation_turn(round : int, danger_level : int) :
	
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
	
			2 :
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
	
	
	
	
	
	
	
