extends Node


# Component application helpers
@onready var apply_all_hidden_event: Node = $ApplyAllHiddenEvent
@onready var apply_mutations_default: Node = $ApplyMutationsDefault


# Other helpers
@onready var sort_best_cells: Node = $SortBestCells
@onready var urgency_overide_mutation: Node = $UrgencyOverideMutation


# Mutations still available during the current round.
var avaible_good_mutations: Array[BrainCellMutation] = []
var avaible_bad_mutations: Array[BrainCellMutation] = []


# Mutation types permanently removed because the player
# selected a prisoner containing them.
var picked_mutation_types: Array[String] = []


# Prevents two consecutive chance-based mutation skips.
var just_skipped_mutations: bool = false


const MAX_EMPTY_BATCH_ATTEMPTS: int = 100


func _ready() -> void:
	GLGameManagerBus.connect(
		"process_next_round",
		_handle_process_next_round
	)

	GLCellManagerBus.connect(
		"prisoner_picked_by_player",
		_handle_prisoner_picked_by_player
	)

	fill_avaible_mutations()


func _handle_mutations(
	cell_constructor: CellConstructor,
	prisoner_cells: Array[BrainCell],
	stat_constructors: Array[StatConstructor]
) -> Array[BrainCell]:
	var force_mutation_urgency: bool = false

	############################
	# FORCE SENTIENT MUTATION  #
	############################

	if (
		not IVMutations.served_sentient_cell
		and cell_constructor.cell_quantity == 4
	):
		var sentient_mutation: BrainCellMutation = (
			get_available_mutation("sentient")
		)

		# Only force sentient when it has not already been
		# picked and removed from the mutation pool.
		if sentient_mutation:
			# A mutation is being served, so the next
			# mutation attempt is allowed to skip again.
			just_skipped_mutations = false

			return serve_sentient_cell_first_round(
				prisoner_cells,
				stat_constructors
			)

		# Prevent checking for an unavailable sentient
		# mutation repeatedly during this round.
		IVMutations.served_sentient_cell = true

	###############
	# EXIT EVENTS #
	###############

	# No unused mutations remain.
	if not _has_available_mutations():
		print("CREATION: no mutations left")
		return prisoner_cells

	# Safe mode does not serve mutations.
	if cell_constructor.cell_quantity < 4:
		print("CREATION: safe mode, skipping mutations")
		return prisoner_cells

	if IVMutations.max_mutations_per_batch <= 0:
		print("CREATION: no mutations allowed, max is 0")
		return prisoner_cells

	####################################
	# CHANCE TO SERVE NO MUTATIONS     #
	####################################

	var random_exit_number: int = randi_range(1, 100)

	if random_exit_number <= IVMutations.chance_to_exit_mutation_loop:
		var override_exit: bool = (
			urgency_overide_mutation._check_overide()
		)

		if override_exit:
			force_mutation_urgency = true

			print(
				"CREATION: urgency override prevented ",
				"mutation skip"
			)

		elif not just_skipped_mutations:
			print(
				"CREATION: mutations skipped | roll: ",
				random_exit_number,
				" | skip chance: ",
				IVMutations.chance_to_exit_mutation_loop
			)

			just_skipped_mutations = true
			return prisoner_cells

		else:
			print(
				"CREATION: prevented mutations from ",
				"being skipped twice consecutively"
			)

	# Mutations will be generated during this attempt.
	# The next attempt may skip normally.
	just_skipped_mutations = false

	#################
	# GET MUTATIONS #
	#################

	var batch_mutations: Array[BrainCellMutation] = []

	################################
	# SHAREHOLDER-DEMAND MUTATION  #
	################################

	var demand_mutation: BrainCellMutation = (
		IVCellCreator.shareholder_demand_cell_mutation
	)

	if demand_mutation:
		var demand_chance: int = randi_range(1, 100)

		if demand_chance <= 50:
			var complete_demand_mutation: BrainCellMutation = (
				get_available_mutation(demand_mutation.type)
			)

			if (
				complete_demand_mutation
				and not _batch_contains_mutation_type(
					batch_mutations,
					complete_demand_mutation.type
				)
			):
				batch_mutations.append(
					complete_demand_mutation
				)

				_remove_available_mutation(
					complete_demand_mutation.type
				)

	########################################
	# KEEP TRYING UNTIL ONE IS SELECTED   #
	########################################

	var empty_batch_attempts: int = 0

	while batch_mutations.is_empty():
		# All remaining mutations may have been removed
		# while this event was being processed.
		if not _has_available_mutations():
			print("CREATION: no mutations left")
			return prisoner_cells

		if empty_batch_attempts >= MAX_EMPTY_BATCH_ATTEMPTS:
			print(
				"CREATION: stopped mutation selection after ",
				MAX_EMPTY_BATCH_ATTEMPTS,
				" empty attempts"
			)
			return prisoner_cells

		var previous_size: int = batch_mutations.size()

		batch_mutations = get_batch_mutations(
			batch_mutations,
			stat_constructors
		)

		if batch_mutations.size() == previous_size:
			empty_batch_attempts += 1
		else:
			empty_batch_attempts = 0

	#######################
	# SORT PRISONER CELLS #
	#######################

	prisoner_cells = sort_best_cells._handle_sort(
		prisoner_cells
	)

	###################
	# APPLY MUTATIONS #
	###################

	if not force_mutation_urgency:
		force_mutation_urgency = (
			urgency_overide_mutation._check_overide()
		)

	if force_mutation_urgency:
		print(
			"CREATION: applying forced hidden mutation event"
		)

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
	stat_constructors: Array[StatConstructor]
) -> Array[BrainCell]:
	var batch_mutations: Array[BrainCellMutation] = []

	var sentient_mutation: BrainCellMutation = (
		get_available_mutation("sentient")
	)

	# Sentient may have already been selected by the player.
	if not sentient_mutation:
		IVMutations.served_sentient_cell = true
		return prisoner_cells

	batch_mutations.append(sentient_mutation)

	# Prevent sentient from being selected twice in this batch.
	_remove_available_mutation("sentient")

	# Roll for additional mutations when more than one is permitted.
	while batch_mutations.size() < IVMutations.max_mutations_per_batch:
		if not _has_available_mutations():
			break

		var previous_size: int = batch_mutations.size()

		batch_mutations = get_batch_mutations(
			batch_mutations,
			stat_constructors
		)

		# Additional mutations are optional.
		if batch_mutations.size() == previous_size:
			break

	prisoner_cells = apply_mutations_default._handle_apply(
		prisoner_cells,
		batch_mutations
	)

	IVMutations.served_sentient_cell = true

	return prisoner_cells


func get_available_mutation(
	mutation_type: String
) -> BrainCellMutation:
	for mutation: BrainCellMutation in avaible_good_mutations:
		if mutation.type == mutation_type:
			return mutation

	for mutation: BrainCellMutation in avaible_bad_mutations:
		if mutation.type == mutation_type:
			return mutation

	return null


func get_batch_mutations(
	batch_mutations: Array[BrainCellMutation],
	stat_constructors: Array[StatConstructor]
) -> Array[BrainCellMutation]:
	var max_mutations_per_batch: int = (
		IVMutations.max_mutations_per_batch
	)

	var min_mutations_per_batch: int = (
		IVMutations.min_mutations_per_batch
	)

	if batch_mutations.size() >= max_mutations_per_batch:
		return batch_mutations

	if not _has_available_mutations():
		return batch_mutations

	var should_force_mutation: bool = (
		batch_mutations.size() < min_mutations_per_batch
	)

	var good_mutation_chance: int = (
		IVMutations.good_mutation_chance
	)

	var bad_mutation_chance: int = (
		IVMutations.bad_mutation_chance
	)

	##########################################
	# APPLY PRISONER-PROFILER SYMBOL CHANGES #
	##########################################

	for stat_constructor: StatConstructor in stat_constructors:
		if not stat_constructor.spare_symbol:
			continue

		if stat_constructor.spare_symbol.type == "good_mutation":
			match stat_constructor.spare_symbol.direction:
				"up":
					good_mutation_chance += 10

				"down":
					good_mutation_chance -= 10

		elif stat_constructor.spare_symbol.type == "bad_mutation":
			match stat_constructor.spare_symbol.direction:
				"up":
					bad_mutation_chance += 10

				"down":
					bad_mutation_chance -= 10

	good_mutation_chance = clampi(
		good_mutation_chance,
		0,
		100
	)

	bad_mutation_chance = clampi(
		bad_mutation_chance,
		0,
		100
	)

	##########################
	# FORCE MINIMUM MUTATION #
	##########################

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

		if (
			selected_mutation
			and not _batch_contains_mutation_type(
				batch_mutations,
				selected_mutation.type
			)
		):
			batch_mutations.append(selected_mutation)

			# Prevent selecting the same mutation twice
			# in this generated batch.
			_remove_available_mutation(
				selected_mutation.type
			)

		return batch_mutations

	######################
	# GOOD MUTATION ROLL #
	######################

	var good_number: int = randi_range(1, 100)

	if (
		good_number <= good_mutation_chance
		and not avaible_good_mutations.is_empty()
	):
		var selected_good_mutation: BrainCellMutation = (
			avaible_good_mutations.pick_random()
		)

		if (
			selected_good_mutation
			and not _batch_contains_mutation_type(
				batch_mutations,
				selected_good_mutation.type
			)
		):
			batch_mutations.append(
				selected_good_mutation
			)

			# Prevent selecting it again in this batch.
			_remove_available_mutation(
				selected_good_mutation.type
			)

		return batch_mutations

	#####################
	# BAD MUTATION ROLL #
	#####################

	var bad_number: int = randi_range(1, 100)

	if (
		bad_number <= bad_mutation_chance
		and not avaible_bad_mutations.is_empty()
	):
		var selected_bad_mutation: BrainCellMutation = (
			avaible_bad_mutations.pick_random()
		)

		if (
			selected_bad_mutation
			and not _batch_contains_mutation_type(
				batch_mutations,
				selected_bad_mutation.type
			)
		):
			batch_mutations.append(
				selected_bad_mutation
			)

			# Prevent selecting it again in this batch.
			_remove_available_mutation(
				selected_bad_mutation.type
			)

	return batch_mutations


func _batch_contains_mutation_type(
	batch_mutations: Array[BrainCellMutation],
	mutation_type: String
) -> bool:
	for mutation: BrainCellMutation in batch_mutations:
		if mutation and mutation.type == mutation_type:
			return true

	return false


func _has_available_mutations() -> bool:
	return (
		not avaible_good_mutations.is_empty()
		or not avaible_bad_mutations.is_empty()
	)


func _remove_available_mutation(
	mutation_type: String
) -> void:
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


func _handle_prisoner_picked_by_player(
	brain_cell: BrainCell
) -> void:
	if not brain_cell:
		return

	for mutation: BrainCellMutation in brain_cell.mutations:
		if not mutation:
			continue

		# Ignore fake mutations.
		if mutation.type.is_empty() or mutation.type == "none":
			continue

		if not picked_mutation_types.has(mutation.type):
			picked_mutation_types.append(mutation.type)

			print(
				"CREATION: permanently removing picked mutation: ",
				mutation.type
			)

		# Remove immediately so it cannot be served again
		# during the current round.
		_remove_available_mutation(mutation.type)


func _handle_process_next_round() -> void:
	fill_avaible_mutations()

	# Allow the forced sentient check again. It will only
	# serve sentient if sentient is still available.
	IVMutations.served_sentient_cell = false

	# Do not reset just_skipped_mutations here.
	# This prevents a skip at the end of one round followed
	# by another skip at the start of the next round.


func fill_avaible_mutations() -> void:
	avaible_good_mutations.clear()
	avaible_bad_mutations.clear()

	#######################
	# LOAD GOOD MUTATIONS #
	#######################

	for mutation: BrainCellMutation in IVMutations.good_mutations:
		if not mutation:
			continue

		# Never re-add mutations from prisoners picked
		# by the player.
		if picked_mutation_types.has(mutation.type):
			continue

		# Prevent duplicate mutation types.
		if get_available_mutation(mutation.type):
			continue

		avaible_good_mutations.append(mutation)

	######################
	# LOAD BAD MUTATIONS #
	######################

	for mutation: BrainCellMutation in IVMutations.bad_mutations:
		if not mutation:
			continue

		# Never re-add mutations from prisoners picked
		# by the player.
		if picked_mutation_types.has(mutation.type):
			continue

		# Prevent duplicate mutation types across both pools.
		if get_available_mutation(mutation.type):
			continue

		avaible_bad_mutations.append(mutation)
