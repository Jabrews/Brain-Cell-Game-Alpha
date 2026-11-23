extends Node

# Components
@onready var trigger_delay_timer: Timer = $TriggerDelayTimer
@onready var get_valid_posible_mutation_event_choices: Node = (
	$GetValidPossibleMutationEvents
)

var last_picked_choice: PossibleMutationEventChoice


func _ready() -> void:
	GLMutationEventBus.trigger_random_mutation_failed.connect(
		_handle_trigger_random_mutation_failed
	)

	trigger_delay_timer.timeout.connect(
		_handle_trigger_delay_timeout
	)

	trigger_delay_timer.one_shot = true
	_set_random_delay()
	trigger_delay_timer.start()


func _handle_trigger_random_mutation_failed() -> void:
	# Failed events should not affect the next selection.
	last_picked_choice = null


func _handle_trigger_delay_timeout() -> void:
	_set_random_delay()
	trigger_mutation_event()
	trigger_delay_timer.start()


func _set_random_delay() -> void:
	trigger_delay_timer.wait_time = randf_range(
		IVRandomMutationEventTrigger.mutation_event_delay_min_wait_time,
		IVRandomMutationEventTrigger.mutation_event_delay_max_wait_time
	)


func trigger_mutation_event() -> void:
	var previous_picked_choice: PossibleMutationEventChoice = last_picked_choice
	last_picked_choice = null

	var possible_mutation_event_choices: Array[PossibleMutationEventChoice] = (
		get_valid_posible_mutation_event_choices._get_possible()
	)

	if possible_mutation_event_choices.is_empty():
		GLMutationEventBus.emit_signal("finished_trigger_event", "")
		return

	# Chance to skip this event.
	var chance_to_skip_event: int = clampi(
		IVRandomMutationEventTrigger.chance_to_skip_mutation_event,
		0,
		100
	)

	if randi_range(1, 100) <= chance_to_skip_event:
		GLMutationEventBus.emit_signal("finished_trigger_event", "")
		return

	# If the only choice just ran, allow it to repeat 25% of the time.
	if (
		possible_mutation_event_choices.size() == 1
		and previous_picked_choice != null
	):
		var only_choice: PossibleMutationEventChoice = (
			possible_mutation_event_choices[0]
		)

		if (
			only_choice != null
			and only_choice.mutation_event == previous_picked_choice.mutation_event
			and only_choice.cell == previous_picked_choice.cell
			and randi_range(1, 100) > 25
		):
			GLMutationEventBus.emit_signal("finished_trigger_event", "")
			return

	# Calculate selection weights.
	var choice_weights: Array[float] = []
	var total_weight: float = 0.0

	for choice: PossibleMutationEventChoice in possible_mutation_event_choices:
		if (
			choice == null
			or choice.mutation_event == null
			or choice.cell == null
		):
			choice_weights.append(0.0)
			continue

		var chance_symbol: int = clampi(
			choice.mutation_event.trigger_chance,
			-1,
			1
		)

		if choice.away_from_player:
			chance_symbol = maxi(chance_symbol - 1, -1)

		if previous_picked_choice != null:
			if (
				choice.mutation_event == previous_picked_choice.mutation_event
				and choice.cell == previous_picked_choice.cell
			):
				chance_symbol = maxi(chance_symbol - 1, -1)

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

	if total_weight <= 0.0:
		GLMutationEventBus.emit_signal("finished_trigger_event", "")
		return

	# Pick a choice using its weight.
	var choice_roll: float = randf() * total_weight
	var current_weight: float = 0.0
	var picked_choice: PossibleMutationEventChoice = null

	for index: int in range(possible_mutation_event_choices.size()):
		if choice_weights[index] <= 0.0:
			continue

		current_weight += choice_weights[index]
		picked_choice = possible_mutation_event_choices[index]

		if choice_roll < current_weight:
			break

	# The last valid choice also serves as a rounding fallback.
	if picked_choice == null:
		GLMutationEventBus.emit_signal("finished_trigger_event", "")
		return

	last_picked_choice = picked_choice

	GLMutationEventBus.emit_signal(
		"attempt_to_trigger_random_mutation_event",
		picked_choice.mutation_event,
		picked_choice.cell
	)
