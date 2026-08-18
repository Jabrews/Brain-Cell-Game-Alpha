extends Node


@onready var progress_bar: TextureProgressBar = $ProgressBar

const FLASH_COLOR := Color(1.0, 0.25, 0.25)

var progress_tween: Tween
var flash_tween: Tween


func _ready() -> void:
	GLGameManagerBus.connect("process_next_round", _handle_next_round)
	GLGameManagerBus.connect("proceed_next_energy_turn", _handle_next_energy_turn)
	GLGameManagerBus.connect("energy_changed", _handle_energy_changed)


func _handle_next_round() -> void:
	var max_energy: int = GLGameManagerBus.max_energy

	progress_bar.min_value = 0
	progress_bar.max_value = max_energy

	_update_progress()


func _handle_next_energy_turn() -> void:
	_update_progress()


func _handle_energy_changed() -> void:
	_update_progress()


func _update_progress() -> void:
	
	await get_tree().create_timer(0.1).timeout
	
	var curr_energy: int = GLGameManagerBus.curr_energy
	var max_energy: int = GLGameManagerBus.max_energy

	if max_energy <= 0:
		progress_bar.value = 0
		return

	# Smoothly move the progress bar.
	if progress_tween:
		progress_tween.kill()

	progress_tween = create_tween()
	progress_tween.set_trans(Tween.TRANS_SINE)
	progress_tween.set_ease(Tween.EASE_IN_OUT)

	progress_tween.tween_property(
		progress_bar,
		"value",
		curr_energy,
		1.5
	)

	_update_low_energy_flash(curr_energy, max_energy)


func _update_low_energy_flash(curr_energy: int, max_energy: int) -> void:
	var percentage := float(curr_energy) / float(max_energy)

	if percentage <= 0.25:
		_start_flash()
	else:
		_stop_flash()


func _start_flash() -> void:
	# Don't create another flash tween if one is already running.
	if flash_tween and flash_tween.is_running():
		return

	flash_tween = create_tween()
	flash_tween.set_loops()

	flash_tween.tween_property(
		progress_bar,
		"modulate",
		FLASH_COLOR,
		0.3
	)

	flash_tween.tween_property(
		progress_bar,
		"modulate",
		Color.WHITE,
		0.3
	)


func _stop_flash() -> void:
	if flash_tween:
		flash_tween.kill()
		flash_tween = null

	progress_bar.modulate = Color.WHITE
