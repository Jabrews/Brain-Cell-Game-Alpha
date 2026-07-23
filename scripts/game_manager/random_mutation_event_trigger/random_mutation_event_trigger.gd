extends Node


# timer 
@onready var mutation_event_delay_timer: Timer = $MutationEventDelay

# helper
@onready var send_mutation_event : Node = $SendMutationEvent




var waiting_for_succession_event: bool = false
var current_event_can_retry: bool = false


func _ready() -> void:
	GLGameManagerBus.connect(
		"process_next_round",
		_handle_process_next_round
	)

	GLMutationEventBus.connect(
		"trigger_random_mutation_failed",
		_handle_trigger_random_mutation_failed
	)

	mutation_event_delay_timer.timeout.connect(
		_handle_mutation_event_delay_timer_timeout
	)

	mutation_event_delay_timer.one_shot = true

	start_regular_event_timer()


func _handle_process_next_round() -> void:
	# Cancel regular and succession events from the previous round.
	mutation_event_delay_timer.stop()
	waiting_for_succession_event = false
	current_event_can_retry = false

	start_regular_event_timer()


func start_regular_event_timer() -> void:
	var min_wait_time: float = (
		IVRandomMutationEventTrigger.mutation_event_delay_min_wait_time
	)

	var max_wait_time: float = (
		IVRandomMutationEventTrigger.mutation_event_delay_max_wait_time
	)

	mutation_event_delay_timer.wait_time = randf_range(
		min_wait_time,
		max_wait_time
	)

	mutation_event_delay_timer.start()


func start_succession_event_timer() -> void:
	waiting_for_succession_event = true

	mutation_event_delay_timer.wait_time = randf_range(
		IVRandomMutationEventTrigger.succession_event_delay_min_wait_timer,
		IVRandomMutationEventTrigger.succession_event_delay_max_wait_timer
	)

	mutation_event_delay_timer.start()


func _handle_mutation_event_delay_timer_timeout() -> void:
	if waiting_for_succession_event:
		waiting_for_succession_event = false

		# Succession events are not retried if they fail.
		current_event_can_retry = false
		send_mutation_event._send_event()

		start_regular_event_timer()
		return

	# Regular events may retry once if they fail.
	current_event_can_retry = true
	var event_was_sent: bool = send_mutation_event._send_event()

	if not event_was_sent:
		start_regular_event_timer()
		return

	var succession_roll: int = randi_range(1, 100)

	if (
		succession_roll
		<= IVRandomMutationEventTrigger.chance_for_succession_event
	):
		start_succession_event_timer()
	else:
		start_regular_event_timer()


func _handle_trigger_random_mutation_failed() -> void:
	# Ignore failed succession events.
	if not current_event_can_retry:
		return

	# Only allow one retry for this regular event.
	current_event_can_retry = false
	send_mutation_event._send_event()
