extends Node

# components
@onready var parent_pris_generator_manager : Node = $".."
# timer components
@onready var increment_loading_advance_timer : Timer = $IncrementLoadingAdvanceTimer
@onready var increment_new_pris_advance_timer : Timer = $IncrementNewPrisonerAdvanceTimer

const LOADING_DISPLAY_DURATION : float = 0.5
const PRISONER_DISPLAY_DURATION : float = 3.0

var loading_curr_duration : int = 0
var prisoner_curr_duration : int = 0

func _ready() -> void:
	increment_loading_advance_timer.timeout.connect(_handle_loading_advance_timeout)
	increment_new_pris_advance_timer.timeout.connect(_handle_new_pris_advance_timeout)

	increment_loading_advance_timer.wait_time = 1.0
	increment_new_pris_advance_timer.wait_time = 1.0
	increment_loading_advance_timer.one_shot = true
	increment_new_pris_advance_timer.one_shot = true


func _start() -> void:
	_start_loading_timer()


func _start_loading_timer() -> void:
	increment_new_pris_advance_timer.stop()
	loading_curr_duration = 0
	increment_loading_advance_timer.start()


func _start_prisoner_timer() -> void:
	increment_loading_advance_timer.stop()
	prisoner_curr_duration = 0
	increment_new_pris_advance_timer.start()


func _handle_loading_advance_timeout() -> void:
	loading_curr_duration += 1

	if loading_curr_duration >= LOADING_DISPLAY_DURATION:
		parent_pris_generator_manager._handle_loading_advance()
	else:
		increment_loading_advance_timer.start()


func _handle_new_pris_advance_timeout() -> void:
	prisoner_curr_duration += 1

	if prisoner_curr_duration >= PRISONER_DISPLAY_DURATION:
		parent_pris_generator_manager._handle_new_prisoner_advance()
	else:
		increment_new_pris_advance_timer.start()


func _toggle_pause(toggle_value: bool) -> void:
	increment_loading_advance_timer.paused = toggle_value
	increment_new_pris_advance_timer.paused = toggle_value


func _stop() -> void:
	increment_loading_advance_timer.paused = false
	increment_new_pris_advance_timer.paused = false

	increment_loading_advance_timer.stop()
	increment_new_pris_advance_timer.stop()

	loading_curr_duration = 0
	prisoner_curr_duration = 0
