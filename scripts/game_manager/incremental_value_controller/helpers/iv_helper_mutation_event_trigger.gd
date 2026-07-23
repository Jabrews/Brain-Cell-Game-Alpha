extends Node

@warning_ignore("shadowed_global_identifier")
func _update_mutations_event_trigger(round : int , energy : int) :
	if round == 1 :
		IVRandomMutationEventTrigger.mutation_event_delay_min_wait_time = 10.0
		IVRandomMutationEventTrigger.mutation_event_delay_max_wait_time = 15.0
		
	
	elif round == 2 :
		pass
		
	elif round == 3 :
		pass

	elif round == 4 :
		pass

	
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
	
	verify_mutation_and_fake_quanity_surpass()
	
	
func verify_mutation_and_fake_quanity_surpass() :
	if IVMutations.max_mutations_per_batch + IVMutations.max_fake_mutations_per_batch > 4 :
		push_error('too many mutations applied. surpasses quanity')
		
	
	
	
	
	
