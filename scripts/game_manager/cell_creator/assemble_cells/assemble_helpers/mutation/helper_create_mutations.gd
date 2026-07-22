extends Node


# Component application helpers
@onready var apply_all_hidden_event: Node = $ApplyAllHiddenEvent
@onready var apply_mutations_default: Node = $ApplyMutationsDefault


# Other helpers
@onready var sort_best_cells: Node = $SortBestCells
@onready var urgency_overide_mutation: Node = $UrgencyOverideMutation


var avaible_good_mutations: Array[BrainCellMutation] = []
var avaible_bad_mutations: Array[BrainCellMutation] = []


func _ready() -> void:
	GLGameManagerBus.connect(
		"process_next_round",
		_handle_process_next_round
	)

	fill_avaible_mutations()


func _handle_mutations(
	cell_constructor: CellConstructor,
	prisoner_cells: Array[BrainCell],
	stat_constructors : Array[StatConstructor],
) -> Array[BrainCell]:
	
	# Turned on when the player urgently needs mutated cells.
	var force_mutation_urgency: bool = false

	# Force the chosen sentient mutation once.
	if (
		not IVMutations.served_sentient_cell
		and cell_constructor.cell_quantity == 4
	):
		return serve_sentient_cell_first_round(prisoner_cells, stat_constructors)

	###############
	# EXIT EVENTS #
	###############

	if (
		avaible_good_mutations.is_empty()
		and avaible_bad_mutations.is_empty()
	):
		return prisoner_cells

	# Safe mode does not serve mutations.
	if cell_constructor.cell_quantity < 4:
		return prisoner_cells

	if IVMutations.max_mutations_per_batch <= 0:
		return prisoner_cells

	# Chance to generate no mutations.
	var random_exit_number: int = randi_range(1, 100)

	if random_exit_number <= IVMutations.chance_to_exit_mutation_loop:
		var override_exit: bool = urgency_overide_mutation._check_overide()

		if override_exit:
			force_mutation_urgency = true
		else:
			return prisoner_cells

	#################
	# GET MUTATIONS #
	#################

	var batch_mutations: Array[BrainCellMutation] = []

	# Possibly include the shareholder-demand mutation.
	var demand_mutation: BrainCellMutation = (
		IVCellCreator.shareholder_demand_cell_mutation
	)

	if demand_mutation:
		var demand_chance: int = randi_range(1, 100)

		if demand_chance <= 50:
			batch_mutations.append(demand_mutation)

	# Keep trying until at least one mutation is selected.
	while batch_mutations.is_empty():
		var previous_size: int = batch_mutations.size()

		batch_mutations = get_batch_mutations(batch_mutations, stat_constructors)

		# Prevent an infinite loop when nothing can be selected.
		if (
			batch_mutations.size() == previous_size
			and avaible_good_mutations.is_empty()
			and avaible_bad_mutations.is_empty()
		):
			return prisoner_cells

	#######################
	# SORT PRISONER CELLS #
	#######################

	prisoner_cells = sort_best_cells._handle_sort(prisoner_cells)

	###################
	# APPLY MUTATIONS #
	###################

	if not force_mutation_urgency:
		force_mutation_urgency = (
			urgency_overide_mutation._check_overide()
		)

	if force_mutation_urgency:
		return apply_all_hidden_event._handle_apply(
			prisoner_cells,
			batch_mutations,
			true
		)

	#########################
	# REGULAR MUTATION EVENT #
	#########################

	var event_number: int = randi_range(1, 100)

	if event_number <= IVMutations.chance_for_all_hidden_event:
		prisoner_cells = apply_all_hidden_event._handle_apply(
			prisoner_cells,
			batch_mutations,
			false
		)
	else:
		prisoner_cells = apply_mutations_default._handle_apply(
			prisoner_cells,
			batch_mutations
		)

	return prisoner_cells


func serve_sentient_cell_first_round(
	prisoner_cells: Array[BrainCell],
	stat_constructors : Array[StatConstructor]
) -> Array[BrainCell]:
	var batch_mutations: Array[BrainCellMutation] = [
		BrainCellMutation.new("sentient", false)
	]

	# Prevent sentient from being selected again in this mutation batch.
	_remove_available_mutation("sentient")

	# Roll for additional mutations when more than one is permitted.
	while batch_mutations.size() < IVMutations.max_mutations_per_batch:
		if (
			avaible_good_mutations.is_empty()
			and avaible_bad_mutations.is_empty()
		):
			break

		var previous_size: int = batch_mutations.size()

		batch_mutations = get_batch_mutations(batch_mutations, stat_constructors)

		# Nothing was selected during this roll.
		if batch_mutations.size() == previous_size:
			break

	prisoner_cells = apply_mutations_default._handle_apply(
		prisoner_cells,
		batch_mutations
	)

	# This remains true after the round changes so sentient is only forced once.
	IVMutations.served_sentient_cell = true

	return prisoner_cells


func get_batch_mutations(
	batch_mutations: Array[BrainCellMutation],
	stat_constructors : Array[StatConstructor]
) -> Array[BrainCellMutation]:
	var max_mutations_per_batch: int = (
		IVMutations.max_mutations_per_batch
	)

	var min_mutations_per_batch: int = (
		IVMutations.min_mutations_per_batch
	)

	if batch_mutations.size() >= max_mutations_per_batch:
		return batch_mutations

	var should_force_mutation: bool = (
		batch_mutations.size() < min_mutations_per_batch
	)


	var good_mutation_chance: int = IVMutations.good_mutation_chance
	var bad_mutation_chance: int = IVMutations.bad_mutation_chance
	
	# Boost or decrease chances depending on active
	# prisoner-profiler symbols.
	for stat_constructor : StatConstructor in stat_constructors : 
		if stat_constructor.spare_symbol.type == 'good_mutation' : 		
			match stat_constructor.spare_symbol.direction : 
				'up' :
					good_mutation_chance += 10
				'down' : 
					good_mutation_chance += -10
		elif stat_constructor.spare_symbol.type == 'bad_mutation' :
			match stat_constructor.spare_symbol.direction : 
				'up' :
					bad_mutation_chance += 10
				'down' : 
					bad_mutation_chance += -10

	if should_force_mutation:
		var all_available_mutations: Array[BrainCellMutation] = []

		all_available_mutations.append_array(
			avaible_good_mutations
		)

		all_available_mutations.append_array(
			avaible_bad_mutations
		)

		if all_available_mutations.is_empty():
			return batch_mutations

		var selected_mutation: BrainCellMutation = (
			all_available_mutations.pick_random()
		)

		if not batch_mutations.has(selected_mutation):
			batch_mutations.append(selected_mutation)

		return batch_mutations

	var good_number: int = randi_range(1, 100)

	if (
		good_number <= good_mutation_chance
		and not avaible_good_mutations.is_empty()
	):
		var selected_good_mutation: BrainCellMutation = (
			avaible_good_mutations.pick_random()
		)

		if not batch_mutations.has(selected_good_mutation):
			batch_mutations.append(selected_good_mutation)

		return batch_mutations

	var bad_number: int = randi_range(1, 100)

	if (
		bad_number <= bad_mutation_chance
		and not avaible_bad_mutations.is_empty()
	):
		var selected_bad_mutation: BrainCellMutation = (
			avaible_bad_mutations.pick_random()
		)

		if not batch_mutations.has(selected_bad_mutation):
			batch_mutations.append(selected_bad_mutation)

	return batch_mutations


func _remove_available_mutation(mutation_type: String) -> void:
	for index: int in range(
		avaible_good_mutations.size() - 1,
		-1,
		-1
	):
		var mutation: BrainCellMutation = (
			avaible_good_mutations[index]
		)

		if mutation.type == mutation_type:
			avaible_good_mutations.remove_at(index)

	for index: int in range(
		avaible_bad_mutations.size() - 1,
		-1,
		-1
	):
		var mutation: BrainCellMutation = (
			avaible_bad_mutations[index]
		)

		if mutation.type == mutation_type:
			avaible_bad_mutations.remove_at(index)


func _handle_process_next_round() -> void:
	fill_avaible_mutations()

	# reset serve sentient cell
	IVMutations.served_sentient_cell = false



func fill_avaible_mutations() -> void:
	# Duplicate the arrays so removing an available mutation does not
	# modify the original round configuration.
	avaible_good_mutations = (
		IVMutations.good_mutations.duplicate()
	)

	avaible_bad_mutations = (
		IVMutations.bad_mutations.duplicate()
	)
	
