extends Node


# Components
@onready var trigger_delay_timer: Timer = $TriggerDelayTimer

# Helper components
@onready var get_valid_posible_mutation_event_choices: Node = (
	$GetValidPossibleMutationEvents
)

var last_picked_choice: PossibleMutationEventChoice

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		trigger_mutation_event()


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

	await get_tree().process_frame

	if GameAdminPanel.enabled:
		GameAdminPanel.updater_random_mutation_event.wait_time_min = (
			random_time_min
		)

		GameAdminPanel.updater_random_mutation_event.wait_time_max = (
			random_time_max
		)

		GameAdminPanel.updater_random_mutation_event.wait_time = (
			trigger_delay_timer.wait_time
		)

	trigger_delay_timer.start()


func _handle_trigger_random_mutation_failed() -> void:
	# A failed event should not be penalized as the previous event.
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

	if GameAdminPanel.enabled:
		await get_tree().process_frame

		GameAdminPanel.updater_random_mutation_event.wait_time_min = (
			random_time_min
		)

		GameAdminPanel.updater_random_mutation_event.wait_time_max = (
			random_time_max
		)

		GameAdminPanel.updater_random_mutation_event.wait_time = (
			trigger_delay_timer.wait_time
		)

	trigger_delay_timer.start()


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

	if GameAdminPanel.enabled:
		GameAdminPanel.updater_random_mutation_event.wait_time_min = (
			random_time_min
		)

		GameAdminPanel.updater_random_mutation_event.wait_time_max = (
			random_time_max
		)

		GameAdminPanel.updater_random_mutation_event.wait_time = (
			trigger_delay_timer.wait_time
		)

	trigger_mutation_event()

	trigger_delay_timer.start()


func trigger_mutation_event() -> void:
	if GameAdminPanel.enabled:
		GameAdminPanel.updater_random_mutation_event.mutation_events.clear()
		GameAdminPanel.updater_random_mutation_event.finale_choice = null
		GameAdminPanel.updater_random_mutation_event.why_none_chose = ""

	var possible_mutation_event_choices: Array[PossibleMutationEventChoice] = get_valid_posible_mutation_event_choices._get_possible()

	if possible_mutation_event_choices.is_empty():
		if GameAdminPanel.enabled:
			GameAdminPanel.updater_random_mutation_event.finale_choice = null
			GameAdminPanel.updater_random_mutation_event.why_none_chose = (
				"no valid random mutation event choices found"
			)

		GLMutationEventBus.emit_signal(
			"finished_trigger_event",
			""
		)

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
		if GameAdminPanel.enabled:
			GameAdminPanel.updater_random_mutation_event.finale_choice = null
			GameAdminPanel.updater_random_mutation_event.why_none_chose = (
				"random mutation skipped : " + str(chance_to_skip_event)
			)

		GLMutationEventBus.emit_signal(
			"finished_trigger_event",
			""
		)

		# Reset last so it can run normally next time.
		last_picked_choice = null

		return

	########################################
	# ONLY ONE EVENT AND IT JUST RAN       #
	########################################

	if (
		possible_mutation_event_choices.size() == 1
		and last_picked_choice != null
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
				if GameAdminPanel.enabled:
					var original_chance: int = clampi(
						only_choice.mutation_event.trigger_chance,
						-1,
						1
					)

					var situation_increase_applied: bool = (
						original_chance == 1
					)

					var adjusted_chance: int = maxi(
						original_chance - 1,
						-1
					)

					var reasons_why_unlikley: Array[String] = ["only available event was the previously selected event"]

					GameAdminPanel.updater_random_mutation_event.mutation_events.append(
							RandomMutationEvent.new(
								only_choice.cell.name,
								only_choice.mutation_event.event_name,
								adjusted_chance,
								situation_increase_applied,
								reasons_why_unlikley
							)
						)

					GameAdminPanel.updater_random_mutation_event.finale_choice = null

					GameAdminPanel.updater_random_mutation_event.why_none_chose = "only available event was the previously selected event"

				GLMutationEventBus.emit_signal(
					"finished_trigger_event",
					""
				)

				return

	#############################
	# CALCULATE EVENT WEIGHTS   #
	#############################

	var choice_weights: Array[float] = []
	var adjusted_chances: Array[int] = []
	var situation_increases_applied: Array[bool] = []
	var choice_reasons: Array[Array] = []

	var total_weight: float = 0.0

	for choice: PossibleMutationEventChoice in (
		possible_mutation_event_choices
	):
		if (
			choice == null
			or choice.mutation_event == null
			or choice.cell == null
		):
			choice_weights.append(0.0)
			adjusted_chances.append(-1)
			situation_increases_applied.append(false)
			choice_reasons.append([])
			continue

		var original_chance: int = clampi(
			choice.mutation_event.trigger_chance,
			-1,
			1
		)

		var chance_symbol: int = original_chance

		# True when the event began with a positive situation increase.
		var situation_increase_applied: bool = (
			original_chance == 1
		)

		var reasons_why_unlikley: Array[String] = []

		#################################
		# CELL AWAY FROM PLAYER         #
		#################################

		if choice.away_from_player:
			chance_symbol = maxi(
				chance_symbol - 1,
				-1
			)

			reasons_why_unlikley.append("cell is away from player's room")

		#################################
		# EVENT WAS LAST PICKED         #
		#################################

		if last_picked_choice != null:
			var same_as_last_choice: bool = (
				choice.mutation_event
				== last_picked_choice.mutation_event
				and choice.cell == last_picked_choice.cell
			)

			if same_as_last_choice:
				chance_symbol = maxi(
					chance_symbol - 1,
					-1
				)

				reasons_why_unlikley.append(
					"event was the previously selected event"
				)

		#########################
		# CONVERT TO WEIGHT     #
		#########################

		var choice_weight: float = 1.0

		match chance_symbol:
			-1:
				choice_weight = 0.5

			0:
				choice_weight = 1.0

			1:
				choice_weight = 1.5

		choice_weights.append(choice_weight)
		adjusted_chances.append(chance_symbol)
		situation_increases_applied.append(
			situation_increase_applied
		)
		choice_reasons.append(reasons_why_unlikley)

		total_weight += choice_weight

		if GameAdminPanel.enabled:
			GameAdminPanel\
				.updater_random_mutation_event\
				.mutation_events.append(
					RandomMutationEvent.new(
						choice.cell.name,
						choice.mutation_event.event_name,
						chance_symbol,
						situation_increase_applied,
						reasons_why_unlikley
					)
				)

	if total_weight <= 0.0:
		if GameAdminPanel.enabled:
			GameAdminPanel.updater_random_mutation_event.finale_choice = null
			GameAdminPanel.updater_random_mutation_event.why_none_chose = (
				"no random mutation choices had valid weight"
			)

		GLMutationEventBus.emit_signal(
			"finished_trigger_event",
			""
		)

		return

	#########################
	# PICK WEIGHTED CHOICE  #
	#########################

	var choice_roll: float = randf_range(
		0.0,
		total_weight
	)

	var current_weight: float = 0.0
	var picked_choice: PossibleMutationEventChoice = null
	var picked_choice_index: int = -1

	for index: int in range(
		possible_mutation_event_choices.size()
	):
		current_weight += choice_weights[index]

		if choice_roll <= current_weight:
			picked_choice = possible_mutation_event_choices[index]
			picked_choice_index = index
			break

	if picked_choice == null:
		# Floating-point safety fallback.
		picked_choice = possible_mutation_event_choices.back()
		picked_choice_index = possible_mutation_event_choices.size() - 1

	if picked_choice == null or picked_choice_index < 0:
		if GameAdminPanel.enabled:
			GameAdminPanel.updater_random_mutation_event.finale_choice = null
			GameAdminPanel.updater_random_mutation_event.why_none_chose = (
				"weighted choice returned null"
			)

		GLMutationEventBus.emit_signal(
			"finished_trigger_event",
			""
		)

		return

	if GameAdminPanel.enabled:
		var picked_reasons: Array[String] = []

		for reason: Variant in choice_reasons[picked_choice_index]:
			picked_reasons.append(str(reason))

		GameAdminPanel.updater_random_mutation_event.finale_choice = (
			RandomMutationEvent.new(
				picked_choice.cell.name,
				picked_choice.mutation_event.event_name,
				adjusted_chances[picked_choice_index],
				situation_increases_applied[picked_choice_index],
				picked_reasons
			)
		)

		GameAdminPanel.updater_random_mutation_event.why_none_chose = ""

	last_picked_choice = picked_choice

	GLMutationEventBus.emit_signal(
		"attempt_to_trigger_random_mutation_event",
		picked_choice.mutation_event,
		picked_choice.cell
	)
