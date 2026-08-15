extends Node

@warning_ignore("shadowed_global_identifier")
func _update_mutations(round : int , energy : int) :
	
	if round == 1 :
		IVMutations.mutations= [
			# airborne
			#IVMutations.all_mutations[0],
			# sentient
			#IVMutations.all_mutations[1],
			# lonley
			#IVMutations.all_mutations[2],
			# disrupter 
			IVMutations.all_mutations[3],



		]
	
	elif round == 2 :
		IVMutations.mutations= [
			# airborne
			#IVMutations.all_mutations[0],
			# sentient
			#IVMutations.all_mutations[1],
			# lonley
			#IVMutations.all_mutations[2],
			# disrupter 
			IVMutations.all_mutations[3],
			# exsplosive 
			#IVMutations.all_mutations[4],
			# cognisance
			#IVMutations.all_mutations[5],
			# telekentic 
			#IVMutations.all_mutations[6],


		]
		
	var danger_level = get_energy_danger_level(energy)
	update_mutation_turn(round, danger_level)
		

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
func update_mutation_turn(round : int, danger_level : int) :
	
	if round == 1 :
		match danger_level :
			0 :
				IVMutations.min_mutations_per_batch = 0
				IVMutations.max_mutations_per_batch = 1
				IVMutations.min_fake_mutations_per_batch = 0
				IVMutations.max_fake_mutations_per_batch = 1
				IVMutations.chance_for_all_hidden_event = 0
				IVMutations.amount_of_best_cells_sorted = 1
				#IVMutations.chance_to_exit_mutation_loop = 50
				IVMutations.chance_to_exit_mutation_loop = 15
				IVMutations.chance_to_hide_mutation = 25

			1 :
				IVMutations.min_mutations_per_batch = 1
				IVMutations.max_mutations_per_batch = 1
				IVMutations.min_fake_mutations_per_batch = 1
				IVMutations.max_fake_mutations_per_batch = 1
				IVMutations.chance_for_all_hidden_event = 10
				IVMutations.amount_of_best_cells_sorted = 2
				#IVMutations.chance_to_exit_mutation_loop = 30
				IVMutations.chance_to_exit_mutation_loop = 15
				IVMutations.chance_to_hide_mutation = 50
			2 :
				IVMutations.min_mutations_per_batch = 1
				IVMutations.max_mutations_per_batch = 2
				IVMutations.min_fake_mutations_per_batch = 1
				IVMutations.max_fake_mutations_per_batch = 2
				IVMutations.chance_for_all_hidden_event = 20
				IVMutations.amount_of_best_cells_sorted = 3
				#IVMutations.chance_to_exit_mutation_loop = 25
				IVMutations.chance_to_exit_mutation_loop = 15
				IVMutations.chance_to_hide_mutation = 50
			3 :
				IVMutations.min_mutations_per_batch = 2
				IVMutations.max_mutations_per_batch = 2
				IVMutations.min_fake_mutations_per_batch = 1
				IVMutations.max_fake_mutations_per_batch = 2
				IVMutations.chance_for_all_hidden_event = 40
				IVMutations.amount_of_best_cells_sorted = 4
				#IVMutations.chance_to_exit_mutation_loop = 20
				IVMutations.chance_to_exit_mutation_loop = 15
				IVMutations.chance_to_hide_mutation = 50

	
	if round == 2 :
		match danger_level :
			0 :
				IVMutations.min_mutations_per_batch = 0
				IVMutations.max_mutations_per_batch = 1
				IVMutations.min_fake_mutations_per_batch = 0
				IVMutations.max_fake_mutations_per_batch = 1
				IVMutations.chance_for_all_hidden_event = 0
				IVMutations.amount_of_best_cells_sorted = 1
				IVMutations.chance_to_exit_mutation_loop = 50
				IVMutations.chance_to_hide_mutation = 25

			1 :
				IVMutations.min_mutations_per_batch = 1
				IVMutations.max_mutations_per_batch = 1
				IVMutations.min_fake_mutations_per_batch = 1
				IVMutations.max_fake_mutations_per_batch = 1
				IVMutations.chance_for_all_hidden_event = 10
				IVMutations.amount_of_best_cells_sorted = 2
				IVMutations.chance_to_exit_mutation_loop = 30
				IVMutations.chance_to_hide_mutation = 50
			2 :
				IVMutations.min_mutations_per_batch = 1
				IVMutations.max_mutations_per_batch = 2
				IVMutations.min_fake_mutations_per_batch = 1
				IVMutations.max_fake_mutations_per_batch = 2
				IVMutations.chance_for_all_hidden_event = 20
				IVMutations.amount_of_best_cells_sorted = 3
				IVMutations.chance_to_exit_mutation_loop = 25
				IVMutations.chance_to_hide_mutation = 50
			3 :
				IVMutations.min_mutations_per_batch = 2
				IVMutations.max_mutations_per_batch = 2
				IVMutations.min_fake_mutations_per_batch = 1
				IVMutations.max_fake_mutations_per_batch = 2
				IVMutations.chance_for_all_hidden_event = 40
				IVMutations.amount_of_best_cells_sorted = 4
				IVMutations.chance_to_exit_mutation_loop = 20
				IVMutations.chance_to_hide_mutation = 50

	
