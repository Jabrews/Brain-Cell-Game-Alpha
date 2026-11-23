extends Node


@warning_ignore("shadowed_global_identifier")
func _update_mutations(round: int, goal_piece: int) -> void:
	
	if round == 1:
		IVMutations.mutations = [
			# airborne
			IVMutations.all_mutations[0],
			# sentient
			IVMutations.all_mutations[1],
			# lonely
			IVMutations.all_mutations[2],
			# disrupter
			IVMutations.all_mutations[3],
			# explosive
			IVMutations.all_mutations[4],
			# cognisance
			IVMutations.all_mutations[5],
			# telekinetic
			IVMutations.all_mutations[6],
		]
	
	update_mutation_turn(round, goal_piece)


@warning_ignore("shadowed_global_identifier")
func update_mutation_turn(round: int, goal_piece: int) -> void:
	
	if round == 1:
		match goal_piece:
			1:
				IVMutations.min_mutations_per_batch = 0
				IVMutations.max_mutations_per_batch = 1
				IVMutations.min_fake_mutations_per_batch = 1
				IVMutations.max_fake_mutations_per_batch = 1
				IVMutations.chance_for_all_hidden_event = 15
				IVMutations.amount_of_best_cells_sorted = 2
				IVMutations.chance_to_exit_mutation_loop = 50
				IVMutations.chance_to_hide_mutation = 50
				IVMutations.chance_to_weight_hidden_stats_low = 1
			
			2:
				IVMutations.min_mutations_per_batch = 1
				IVMutations.max_mutations_per_batch = 2
				IVMutations.min_fake_mutations_per_batch = 1
				IVMutations.max_fake_mutations_per_batch = 2
				IVMutations.chance_for_all_hidden_event = 20
				IVMutations.amount_of_best_cells_sorted = 2
				IVMutations.chance_to_exit_mutation_loop = 20
				IVMutations.chance_to_hide_mutation = 60
				IVMutations.chance_to_weight_hidden_stats_low = 25
			
			3:
				IVMutations.min_mutations_per_batch = 1
				IVMutations.max_mutations_per_batch = 2
				IVMutations.min_fake_mutations_per_batch = 1
				IVMutations.max_fake_mutations_per_batch = 2
				IVMutations.chance_for_all_hidden_event = 25
				IVMutations.amount_of_best_cells_sorted = 3
				IVMutations.chance_to_exit_mutation_loop = 15
				IVMutations.chance_to_hide_mutation = 60
				IVMutations.chance_to_weight_hidden_stats_low = 50
			
			4:
				IVMutations.min_mutations_per_batch = 2
				IVMutations.max_mutations_per_batch = 2
				IVMutations.min_fake_mutations_per_batch = 1
				IVMutations.max_fake_mutations_per_batch = 2
				IVMutations.chance_for_all_hidden_event = 45
				IVMutations.amount_of_best_cells_sorted = 4
				IVMutations.chance_to_exit_mutation_loop = 10
				IVMutations.chance_to_hide_mutation = 75
				IVMutations.chance_to_weight_hidden_stats_low = 75
	
	elif round == 2:
		match goal_piece:
			1:
				IVMutations.min_mutations_per_batch = 0
				IVMutations.max_mutations_per_batch = 1
				IVMutations.min_fake_mutations_per_batch = 0
				IVMutations.max_fake_mutations_per_batch = 1
				IVMutations.chance_for_all_hidden_event = 0
				IVMutations.amount_of_best_cells_sorted = 1
				IVMutations.chance_to_exit_mutation_loop = 50
				IVMutations.chance_to_hide_mutation = 25
			
			2:
				IVMutations.min_mutations_per_batch = 1
				IVMutations.max_mutations_per_batch = 1
				IVMutations.min_fake_mutations_per_batch = 1
				IVMutations.max_fake_mutations_per_batch = 1
				IVMutations.chance_for_all_hidden_event = 10
				IVMutations.amount_of_best_cells_sorted = 2
				IVMutations.chance_to_exit_mutation_loop = 30
				IVMutations.chance_to_hide_mutation = 50
			
			3:
				IVMutations.min_mutations_per_batch = 1
				IVMutations.max_mutations_per_batch = 2
				IVMutations.min_fake_mutations_per_batch = 1
				IVMutations.max_fake_mutations_per_batch = 2
				IVMutations.chance_for_all_hidden_event = 20
				IVMutations.amount_of_best_cells_sorted = 3
				IVMutations.chance_to_exit_mutation_loop = 25
				IVMutations.chance_to_hide_mutation = 50
			
			4:
				IVMutations.min_mutations_per_batch = 2
				IVMutations.max_mutations_per_batch = 2
				IVMutations.min_fake_mutations_per_batch = 1
				IVMutations.max_fake_mutations_per_batch = 2
				IVMutations.chance_for_all_hidden_event = 40
				IVMutations.amount_of_best_cells_sorted = 4
				IVMutations.chance_to_exit_mutation_loop = 20
				IVMutations.chance_to_hide_mutation = 50
