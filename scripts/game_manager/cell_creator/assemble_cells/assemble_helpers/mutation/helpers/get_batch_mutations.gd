
extends Node


var available_mutations: Array[BrainCellMutation] = []


func _ready() -> void:
	GLGameManagerBus.connect(
		"process_next_round",
		_handle_process_next_round
	)
	
	GLCellManagerBus.connect('prisoner_picked_by_player', _handle_prisoner_picked_by_player)
	

	_fill_available_mutations()


func _get_mutations(
	energy_phase: int
) -> Array[BrainCellMutation]:
	var selected_mutations: Array[BrainCellMutation] = []

	if available_mutations.is_empty():
		return selected_mutations

	var min_amount: int = IVMutations.min_mutations_per_batch
	var max_amount: int = IVMutations.max_mutations_per_batch

	if max_amount <= 0:
		return selected_mutations

	if min_amount < 0:
		push_error("Minimum mutations cannot be below 0.")
		min_amount = 0

	if min_amount > max_amount:
		push_error("Minimum mutations cannot be above maximum.")
		min_amount = max_amount

	var mutation_amount: int = min_amount
	var extra_mutation_chance: int = (
		get_energy_phase_chance(energy_phase)
	)

	var extra_slots: int = max_amount - min_amount

	for slot: int in range(extra_slots):
		var roll: int = randi_range(1, 100)

		if roll <= extra_mutation_chance:
			mutation_amount += 1

	if mutation_amount > available_mutations.size():
		mutation_amount = available_mutations.size()

	# Temporary pool used only for this batch.
	var mutation_pool: Array[BrainCellMutation] = (
		available_mutations.duplicate()
	)

	for amount: int in range(mutation_amount):
		if mutation_pool.is_empty():
			break

		var selected_mutation: BrainCellMutation = (
			mutation_pool.pick_random()
		)

		selected_mutations.append(selected_mutation)

		# Prevent this mutation type from being selected
		# more than once in the current batch.
		for index: int in range(
			mutation_pool.size() - 1,
			-1,
			-1
		):
			if mutation_pool[index].type == selected_mutation.type:
				mutation_pool.remove_at(index)

	return selected_mutations

func get_energy_phase_chance(
	energy_phase: int
) -> int:
	match energy_phase:
		0:
			return 25

		1:
			return 50

		2:
			return 75

		_:
			push_error(
				"Invalid mutation energy phase: %s"
				% energy_phase
			)
			return 0


func _handle_process_next_round() -> void:
	_fill_available_mutations()


func _fill_available_mutations() -> void:
	available_mutations = IVMutations.mutations.duplicate()
	
func _handle_prisoner_picked_by_player(prisoner_cell : BrainCell) :
	
	for mutation in prisoner_cell.mutations : 
		
		# if mutation is revealed and its been picked then add info to file cabinet
		if mutation.hidden == false : 
			GLMutationSeenManagerBus.emit_signal('mutation_seen_by_player', mutation.type)
		
		# remove from avaible
		for avaible_mutation : BrainCellMutation in available_mutations : 		
			if avaible_mutation.type == mutation.type : 
				available_mutations.erase(avaible_mutation)
			
		
		
		
		
		
