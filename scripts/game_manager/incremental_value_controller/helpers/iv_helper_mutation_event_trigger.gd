extends Node


@warning_ignore("shadowed_global_identifier")
func _update_mutations_event_trigger(round: int, goal_piece: int) -> void:
	
	if round == 1:
		pass
	
	elif round == 2:
		pass
	
	update_mutation_turn(round, goal_piece)


@warning_ignore("shadowed_global_identifier")
func update_mutation_turn(round: int, goal_piece: int) -> void:
	
	if round == 1:
		match goal_piece:
			1:
				IVRandomMutationEventTrigger.mutation_event_delay_min_wait_time = 25.0
				IVRandomMutationEventTrigger.mutation_event_delay_max_wait_time = 45.0
				IVRandomMutationEventTrigger.chance_to_skip_mutation_event = 35
			
			2:
				IVRandomMutationEventTrigger.mutation_event_delay_min_wait_time = 20.0
				IVRandomMutationEventTrigger.mutation_event_delay_max_wait_time = 35.0
				IVRandomMutationEventTrigger.chance_to_skip_mutation_event = 30
			
			3:
				IVRandomMutationEventTrigger.mutation_event_delay_min_wait_time = 15.0
				IVRandomMutationEventTrigger.mutation_event_delay_max_wait_time = 30.0
				IVRandomMutationEventTrigger.chance_to_skip_mutation_event = 25
			
			4:
				IVRandomMutationEventTrigger.mutation_event_delay_min_wait_time = 15.0
				IVRandomMutationEventTrigger.mutation_event_delay_max_wait_time = 20.0
				IVRandomMutationEventTrigger.chance_to_skip_mutation_event = 25
	
	elif round == 2:
		pass
	
	verify_mutation_and_fake_quantity_surpass()


func verify_mutation_and_fake_quantity_surpass() -> void:
	
	if IVMutations.max_mutations_per_batch + IVMutations.max_fake_mutations_per_batch > 4:
		push_error("Too many mutations applied. Surpasses quantity.")
