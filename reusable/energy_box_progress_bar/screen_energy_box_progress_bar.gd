extends Node


@onready var progress_bar: TextureProgressBar = $ProgressBar

const TOTAL_BARS: int = 20


func _ready() -> void:
	GLGameManagerBus.connect("process_next_round", _handle_next_round)
	GLGameManagerBus.connect("proceed_next_energy_turn", _handle_next_energy_turn)
	GLGameManagerBus.connect("energy_changed", _handle_energy_changed)


func _handle_next_round() -> void:
	var max_energy: int = GLGameManagerBus.max_energy

	# Progress bar represents the full energy range.
	progress_bar.min_value = 0
	progress_bar.max_value = max_energy

	_update_progress()


func _handle_next_energy_turn() -> void:
	_update_progress()


func _handle_energy_changed() -> void:
	_update_progress()


func _update_progress() -> void:
	var curr_energy: int = GLGameManagerBus.curr_energy
	var max_energy: int = GLGameManagerBus.max_energy

	if max_energy <= 0:
		progress_bar.value = 0
		return

	progress_bar.value = curr_energy
