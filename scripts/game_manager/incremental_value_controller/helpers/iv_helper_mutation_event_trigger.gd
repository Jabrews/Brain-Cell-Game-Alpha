extends Node

@warning_ignore("shadowed_global_identifier")
func _update_mutations_event_trigger(round : int , energy : int) :
	if round == 1 :
		IVRandomMutationEventTrigger.mutation_event_delay_min_wait_time = 10.0
		IVRandomMutationEventTrigger.mutation_event_delay_max_wait_time = 15.0
		IVRandomMutationEventTrigger.chance_to_skip_mutation_event = 0
	
	elif round == 2 :
		IVRandomMutationEventTrigger.mutation_event_delay_min_wait_time = 20.0
		IVRandomMutationEventTrigger.mutation_event_delay_max_wait_time = 25.0
		IVRandomMutationEventTrigger.chance_to_skip_mutation_event = 30
		
	elif round == 3 :
		IVRandomMutationEventTrigger.mutation_event_delay_min_wait_time = 20.0
		IVRandomMutationEventTrigger.mutation_event_delay_max_wait_time = 30.0
		IVRandomMutationEventTrigger.chance_to_skip_mutation_event = 20

	elif round == 4 :
		IVRandomMutationEventTrigger.mutation_event_delay_min_wait_time = 15.0
		IVRandomMutationEventTrigger.mutation_event_delay_max_wait_time = 25.0
		IVRandomMutationEventTrigger.chance_to_skip_mutation_event = 15

	
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
		
	
	
	
	
	
