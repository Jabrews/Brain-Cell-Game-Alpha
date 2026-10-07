extends Node

## Components
@onready var trigger_delay_timer: Timer = $TriggerDelayTimer
@onready var inital_delay_timer: Timer = $InitalDelayTimer

# Event handlers
@onready var sickness_cell_container : Node = $Helpers/SicknessCellContainer
@onready var bubble_cell_container : Node = $Helpers/BubbleCellContainer
@onready var jolt_single_interpreter : Node = $Helpers/JoltSingleInterpreter
@onready var jolt_all_interpreters : Node = $Helpers/JoltAllInterpreters

var all_defect_events: Array[DefectEvent] = []
var availbe_defect_events: Array[DefectEvent] = []


func _ready() -> void:
	# Restart timers manually after each timeout.
	trigger_delay_timer.one_shot = true
	inital_delay_timer.one_shot = true

	trigger_delay_timer.timeout.connect(_handle_trigger_delay_timer_timeout)
	inital_delay_timer.timeout.connect(_handle_inital_delay_timer_timeout)

	GLGameManagerBus.connect(
		"process_new_ivs",
		_handle_process_new_ivs
	)


func _handle_process_new_ivs() -> void:
	var new_events: Array[DefectEvent] = (
		IVDefectEventManager.defect_events_avaible.duplicate()
	)

	# Skip if the event list hasn't changed.
	if all_defect_events == new_events:
		return

	# Keep independent copies so removing an available event
	# doesn't change the full event list or the manager's list.
	all_defect_events = new_events
	availbe_defect_events = all_defect_events.duplicate()

	trigger_delay_timer.stop()
	inital_delay_timer.stop()

	# set timer
	trigger_delay_timer.wait_time = IVDefectEventManager.defect_event_trigger_wait_time
	inital_delay_timer.wait_time = IVDefectEventManager.inital_wait_time

	inital_delay_timer.start()


func _handle_inital_delay_timer_timeout() -> void:
	_start_trigger_timer_if_events_remain()


func _handle_trigger_delay_timer_timeout() -> void:
	for defect_event: DefectEvent in availbe_defect_events:
		var ran_num: int = randi_range(1, 100)

		if ran_num <= defect_event.chance_to_choose:
			_trigger_defect_event(defect_event)
			availbe_defect_events.erase(defect_event)
			break

	_start_trigger_timer_if_events_remain()


func _trigger_defect_event(defect_event: DefectEvent) -> void:
	match defect_event.defect_event_type:
		"sickness_cell_container":
			sickness_cell_container._initate()

		"jolt_single_hidden_interpreter":
			jolt_single_interpreter._initate()

		"jolt_all_hidden_interpreter":
			jolt_all_interpreters._initate()

		"bubble_cell_container":
			bubble_cell_container._initate()


func _start_trigger_timer_if_events_remain() -> void:
	if availbe_defect_events.is_empty():
		return

	trigger_delay_timer.start()
