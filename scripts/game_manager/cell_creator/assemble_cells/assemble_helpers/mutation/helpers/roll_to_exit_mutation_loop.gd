extends Node


var just_exited_mutation_loop : bool = false

func _ready() -> void:
	GLGameManagerBus.connect('process_next_round', _handle_process_next_round)



func _handle_roll(energy_phase: int) -> bool:
	match energy_phase:
		0:
			# High energy:
			# Always allow a roll to skip mutations.
			return roll_to_exit_mutation_loop()

		1:
			# Medium energy:
			# Never allow two skips consecutively.
			if just_exited_mutation_loop:
				just_exited_mutation_loop = false
				return false

			var should_exit: bool = roll_to_exit_mutation_loop()

			if should_exit:
				just_exited_mutation_loop = true

			return should_exit

		2:
			# Low energy:
			# Never skip mutations.
			just_exited_mutation_loop = false
			return false

		_:
			push_error(
				"Invalid mutation energy phase: %s"
				% energy_phase
			)
			return false


func roll_to_exit_mutation_loop() -> bool:
	var chance_to_exit: int = clampi(
		IVMutations.chance_to_exit_mutation_loop,
		0,
		100
	)

	var random_number: int = randi_range(1, 100)

	return random_number <= chance_to_exit


func _handle_process_next_round() :
	just_exited_mutation_loop = false
