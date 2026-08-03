extends Node


# Components
@onready var trigger_delay_timer: Timer = $TriggerDelayTimer

# Helper components
@onready var get_valid_posible_mutation_event_choices: Node = (
	$GetValidPossibleMutationEvents
)


var last_picked_choice: PossibleMutationEventChoice


func _ready() -> void:
	GLGameManagerBus.connect(
		"process_next_round",
		_handle_process_next_round
	)

	GLMutationEventBus.connect(
		"trigger_random_mutation_failed",
		_handle_trigger_random_mutation_failed
	)

	trigger_delay_timer.timeout.connect(
		_handle_trigger_delay_timeout
	)

	trigger_delay_timer.one_shot = true
	trigger_delay_timer.start()


func _handle_trigger_random_mutation_failed() -> void:
	#print("Random mutation event failed.")

	# The event did not successfully run, so do not penalize
	# it as the previously used event.
	last_picked_choice = null


func _handle_process_next_round() -> void:
	last_picked_choice = null

	trigger_delay_timer.stop()

	var random_time_min: float = (
		IVRandomMutationEventTrigger
		.mutation_event_delay_min_wait_time
	)

	var random_time_max: float = (
		IVRandomMutationEventTrigger
		.mutation_event_delay_max_wait_time
	)

	trigger_delay_timer.wait_time = randf_range(
		random_time_min,
		random_time_max
	)

	trigger_delay_timer.start()

	#print(
		#"Random mutation timer reset for round ",
		#GLGameManagerBus.current_round,
		#". Next attempt in ",
		#trigger_delay_timer.wait_time,
		#" seconds."
	#)


func _handle_trigger_delay_timeout() -> void:
	var random_time_min: float = (
		IVRandomMutationEventTrigger
		.mutation_event_delay_min_wait_time
	)

	var random_time_max: float = (
		IVRandomMutationEventTrigger
		.mutation_event_delay_max_wait_time
	)

	trigger_delay_timer.wait_time = randf_range(
		random_time_min,
		random_time_max
	)

	trigger_mutation_event()

	trigger_delay_timer.start()


func trigger_mutation_event() -> void:
	var possible_mutation_event_choices: Array[PossibleMutationEventChoice] = get_valid_posible_mutation_event_choices._get_possible()

	if possible_mutation_event_choices.is_empty():
		print("No valid random mutation event choices found.")
		return

	########################
	# SKIP EVENT CHANCE    #
	########################

	var chance_to_skip_event: int = clampi(
		IVRandomMutationEventTrigger.chance_to_skip_mutation_event,
		0,
		100
	)

	var skip_roll: int = randi_range(1, 100)

	if skip_roll <= chance_to_skip_event:
		#print(
			#"Random mutation event skipped. Roll: ",
			#skip_roll,
			#" | Required above: ",
			#chance_to_skip_event
		#)
		return

	########################################
	# ONLY ONE EVENT AND IT JUST RAN       #
	########################################

	if (
		possible_mutation_event_choices.size() == 1
		and last_picked_choice
	):
		var only_choice: PossibleMutationEventChoice = (
			possible_mutation_event_choices[0]
		)

		var same_as_last_choice: bool = (
			only_choice.mutation_event
			== last_picked_choice.mutation_event
			and only_choice.cell == last_picked_choice.cell
		)

		if same_as_last_choice:
			var repeat_roll: int = randi_range(1, 100)

			# Only allow the sole event to repeat 25% of the time.
			if repeat_roll > 25:
				#print(
					#"Prevented the only mutation event from ",
					#"running twice. Repeat roll: ",
					#repeat_roll
				#)
				return

			#print(
				#"Allowing the only mutation event to repeat. ",
				#"Repeat roll: ",
				#repeat_roll
			#)

	#############################
	# CALCULATE EVENT WEIGHTS   #
	#############################

	var choice_weights: Array[float] = []
	var total_weight: float = 0.0

	for choice: PossibleMutationEventChoice in (
		possible_mutation_event_choices
	):
		if not choice or not choice.mutation_event:
			choice_weights.append(0.0)
			continue

		# The original chance symbol must be -1, 0, or 1.
		var chance_symbol: int = clampi(
			choice.mutation_event.trigger_chance,
			-1,
			1
		)

		# Events away from the player receive -1.
		if choice.away_from_player:
			chance_symbol = clampi(
				chance_symbol - 1,
				-1,
				1
			)

		# The last event that ran also receives -1.
		if last_picked_choice:
			var same_as_last_choice: bool = (
				choice.mutation_event
				== last_picked_choice.mutation_event
				and choice.cell == last_picked_choice.cell
			)

			if same_as_last_choice:
				chance_symbol = clampi(
					chance_symbol - 1,
					-1,
					1
				)

		# Each event starts with an equal base weight.
		# -1 means 50% less.
		#  0 means unchanged.
		#  1 means 50% more.
		var choice_weight: float = 1.0

		match chance_symbol:
			-1:
				choice_weight = 0.5

			0:
				choice_weight = 1.0

			1:
				choice_weight = 1.5

		choice_weights.append(choice_weight)
		total_weight += choice_weight

		print(
			"Mutation choice weight | cell: ",
			choice.cell.name,
			" | event: ",
			choice.mutation_event,
			" | symbol: ",
			chance_symbol,
			" | weight: ",
			choice_weight,
			" | away: ",
			choice.away_from_player
		)

	if total_weight <= 0.0:
		print("No random mutation choices had a valid weight.")
		return

	#########################
	# PICK WEIGHTED CHOICE  #
	#########################

	var choice_roll: float = randf_range(0.0, total_weight)
	var current_weight: float = 0.0

	var picked_choice: PossibleMutationEventChoice

	for index: int in range(
		possible_mutation_event_choices.size()
	):
		current_weight += choice_weights[index]

		if choice_roll <= current_weight:
			picked_choice = possible_mutation_event_choices[index]
			break

	if not picked_choice:
		# Floating-point safety fallback.
		picked_choice = possible_mutation_event_choices.back()

	last_picked_choice = picked_choice

	#print(
		#"Triggering random mutation event | cell: ",
		#picked_choice.cell.name,
		#" | event: ",
		#picked_choice.mutation_event,
		#" | away from player: ",
		#picked_choice.away_from_player
	#)

	GLMutationEventBus.emit_signal(
		"attempt_to_trigger_random_mutation_event",
		picked_choice.mutation_event,
		picked_choice.cell
	)
