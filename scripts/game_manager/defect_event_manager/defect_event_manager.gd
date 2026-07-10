extends Node

## components
@onready var defect_event_update_timer: Timer = $DefectEventUpdateTimer
@onready var jolt_hidden_stat_interpreter: Node = $JoltHiddenStatInterpreter
@onready var jolt_cell_container: Node = $JoltCellContainer

@export var timer_decrease_per_trash_cell: float = 2.0
@export var min_timer_timeout_time: float = 8.0

var curr_timer_timeout_time: float


func _ready() -> void:
	GLGameManagerBus.connect("process_next_round", _handle_next_round)
	GLCellTrashcanBus.connect("cell_added_to_trashcan", _handle_cell_added_to_trash_can)

	defect_event_update_timer.connect("timeout", _on_event_timer_timeout)

	_reset_timer_timeout()
	_restart_event_timer()


func _handle_next_round() -> void:
	_reset_timer_timeout()
	_restart_event_timer()


func _handle_cell_added_to_trash_can() -> void:
	curr_timer_timeout_time -= timer_decrease_per_trash_cell
	curr_timer_timeout_time = max(curr_timer_timeout_time, min_timer_timeout_time)


func _on_event_timer_timeout() -> void:
	chance_for_defect_event()
	_restart_event_timer()


func chance_for_defect_event() -> void:
	var no_event_chance: int = IVDefectEventManager.no_event_chance
	var jolt_cell_container_chance: int = IVDefectEventManager.jolt_cell_container_chance
	var jolt_hidden_stat_interpreter_chance: int = IVDefectEventManager.jolt_hidden_stat_interpreter_chance

	var ran_num: int = randi_range(1, 100)

	if ran_num <= no_event_chance:
		return

	elif ran_num <= no_event_chance + jolt_hidden_stat_interpreter_chance:
		jolt_hidden_stat_interpreter._handle_jolt()

	elif ran_num <= (
		no_event_chance
		+ jolt_hidden_stat_interpreter_chance
		+ jolt_cell_container_chance
	):
		jolt_cell_container._handle_jolt()


func _reset_timer_timeout() -> void:
	curr_timer_timeout_time = IVDefectEventManager.max_defect_event_update_timer_duration


func _restart_event_timer() -> void:
	defect_event_update_timer.wait_time = curr_timer_timeout_time
	defect_event_update_timer.start()
