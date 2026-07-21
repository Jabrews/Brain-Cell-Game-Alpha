extends Node

@warning_ignore("shadowed_global_identifier")
func _update_mutations(round : int , energy : int) :
	
	if round == 1 :
		IVMutations.good_mutations= [
			BrainCellMutation.new('sentient', false),
		]
		IVMutations.bad_mutations= []
		
		IVMutations.min_mutations_per_batch = 0
		IVMutations.max_mutations_per_batch = 0
		IVMutations.min_fake_mutations_per_batch = 0
		IVMutations.max_fake_mutations_per_batch = 0
		IVMutations.chance_for_all_hidden_event = 0
		IVMutations.amount_of_best_cells_sorted = 4
		
		# most these dont matter for first round
		IVMutations.chance_to_exit_mutation_loop = 1
		IVMutations.good_mutation_chance= 99
		IVMutations.bad_mutation_chance= 0
		IVMutations.chance_to_hide_mutation = 0
		
		
	
	elif round == 2 :
		IVMutations.good_mutations= [
			BrainCellMutation.new('airborne', false),
			BrainCellMutation.new('sentient', false),
		]
		IVMutations.bad_mutations= [
			BrainCellMutation.new('lonley', false),
			BrainCellMutation.new('disrupter', false),
		]
		
		IVMutations.min_mutations_per_batch = 1
		IVMutations.max_mutations_per_batch = 2
		IVMutations.min_fake_mutations_per_batch = 0
		IVMutations.max_fake_mutations_per_batch = 1
		IVMutations.chance_for_all_hidden_event = 35
		IVMutations.amount_of_best_cells_sorted = 2
		
		IVMutations.chance_to_exit_mutation_loop = 25
		IVMutations.good_mutation_chance = 40
		IVMutations.bad_mutation_chance= 50
		IVMutations.chance_to_hide_mutation = 50
		
	elif round == 3 :
		IVMutations.good_mutations= [
			BrainCellMutation.new('sentient', false),
			BrainCellMutation.new('teleportation', false),
		]
		
		IVMutations.bad_mutations= [
			BrainCellMutation.new('infectious', false),
			BrainCellMutation.new('lonley', false),
			BrainCellMutation.new("exsplosive", false),
			BrainCellMutation.new('cognisance', false),
		]
		
		IVMutations.min_mutations_per_batch = 1
		IVMutations.max_mutations_per_batch = 2
		IVMutations.min_fake_mutations_per_batch = 1
		IVMutations.max_fake_mutations_per_batch = 2
		IVMutations.chance_for_all_hidden_event = 40
		IVMutations.amount_of_best_cells_sorted = 3
		
		IVMutations.chance_to_exit_mutation_loop = 20
		IVMutations.good_mutation_chance = 50
		IVMutations.bad_mutation_chance= 60
		IVMutations.chance_to_hide_mutation = 75
	
		
	elif round == 4 :
		IVMutations.good_mutations= [
			BrainCellMutation.new('airborne', false),
			BrainCellMutation.new('teleportation', false),
			BrainCellMutation.new('sentient', false),
		]
		IVMutations.bad_mutations = [
			BrainCellMutation.new('disrupter', false),
			BrainCellMutation.new("exsplosive", false),
			BrainCellMutation.new('infectious', false),
			BrainCellMutation.new('telekinetic', false),
			BrainCellMutation.new('unstable', false),
		]
		
		IVMutations.min_mutations_per_batch = 2
		IVMutations.max_mutations_per_batch = 2
		IVMutations.min_fake_mutations_per_batch = 1
		IVMutations.max_fake_mutations_per_batch = 2
		IVMutations.chance_for_all_hidden_event = 50
		IVMutations.amount_of_best_cells_sorted = 4
		
		IVMutations.chance_to_exit_mutation_loop = 10
		IVMutations.good_mutation_chance = 40
		IVMutations.bad_mutation_chance= 70
		IVMutations.chance_to_hide_mutation = 60

	
	var danger_level = get_energy_danger_level(energy)
	update_mutation_turn(round, danger_level)
		

func get_energy_danger_level(energy : int) -> int:
	# high energy = safer
	# low energy = more dangerous
	
	var max_energy = GLGameManagerBus.max_energy

	if energy > max_energy * 0.80:
		return 0
	elif energy > max_energy * 0.6:
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
				IVMutations.min_mutations_per_batch = 1
				IVMutations.max_mutations_per_batch = 1
			2 :
				IVMutations.min_mutations_per_batch = 1
				IVMutations.max_mutations_per_batch = 1
			3 :
				IVMutations.min_mutations_per_batch = 1
				IVMutations.max_mutations_per_batch = 1

	
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
	
	verify_mutation_and_fake_quanity_surpass()
	
	
func verify_mutation_and_fake_quanity_surpass() :
	if IVMutations.max_mutations_per_batch + IVMutations.max_fake_mutations_per_batch > 4 :
		push_error('too many mutations applied. surpasses quanity')
		
	
	
	
	
	
