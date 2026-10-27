extends Node

# Components
@onready var dissolve_delay_timer: Timer = $DissolveDelayTimer
@onready var helper_dissolve_cell: Node = $"../HelperDissolveCell"
@onready var helper_refresh_displays: Node = $"../HelperRefreshDisplays"
@onready var handle_threshold_stat_finished: Node = $"../HandleThresholdStatFinished"
@onready var elevator_manager: Node = $"../ElevatorManager"

var valid_dissolving_stats: Array[DissolvingStat] = []


func _ready() -> void:
	dissolve_delay_timer.connect(
		"timeout",
		_handle_dissolve_delay_timer_timeout
	)


func _refresh() -> void:
	var dissolving_cell: DissolvingCell = helper_dissolve_cell.dissolving_cell
	valid_dissolving_stats.clear()

	if dissolving_cell == null:
		dissolve_delay_timer.stop()
		helper_refresh_displays._refresh()
		return

	_rebuild_valid_dissolving_stats(dissolving_cell)

	if valid_dissolving_stats.is_empty():
		_finish_dissolving_cell(dissolving_cell)
	else:
		dissolve_delay_timer.start()

	helper_refresh_displays._refresh()


func _handle_dissolve_delay_timer_timeout() -> void:
	var dissolving_cell: DissolvingCell = helper_dissolve_cell.dissolving_cell

	if dissolving_cell == null:
		dissolve_delay_timer.stop()
		return

	# Dissolve each valid stat by one.
	for dissolving_stat: DissolvingStat in valid_dissolving_stats:
		var threshold_stat: ThresholdStat = (
			dissolving_stat.corresponding_threshold_stat
		)

		if threshold_stat.disabled or threshold_stat.finished:
			continue

		# Stop when only the defect-ignored amount remains.
		if dissolving_stat.amount_to_decrease <= dissolving_stat.defect_ignore:
			continue

		dissolving_stat.amount_to_decrease -= 1.0
		threshold_stat.current_value = maxf(
			threshold_stat.current_value - 1.0,
			0.0
		)

		if threshold_stat.current_value <= 0.0:
			threshold_stat.finished = true
			GLGoalThresholdManagerBus.emit_signal(
				"play_sound",
				"goal_complete_ding"
			)
			handle_threshold_stat_finished._handle(dissolving_cell)

	helper_refresh_displays._refresh()

	# Something else may have replaced the cell during this tick.
	if helper_dissolve_cell.dissolving_cell != dissolving_cell:
		return

	_rebuild_valid_dissolving_stats(dissolving_cell)

	if valid_dissolving_stats.is_empty():
		_finish_dissolving_cell(dissolving_cell)


func _rebuild_valid_dissolving_stats(
	dissolving_cell: DissolvingCell
) -> void:
	valid_dissolving_stats.clear()

	var dissolving_stats: Array[DissolvingStat] = [
		dissolving_cell.strength_dissolving_stat,
		dissolving_cell.intelligence_dissolving_stat,
		dissolving_cell.community_dissolving_stat,
	]

	for dissolving_stat: DissolvingStat in dissolving_stats:
		var threshold_stat: ThresholdStat = (
			dissolving_stat.corresponding_threshold_stat
		)

		if threshold_stat.disabled or threshold_stat.finished:
			continue

		# No clean amount remains to dissolve.
		if dissolving_stat.amount_to_decrease <= dissolving_stat.defect_ignore:
			continue

		valid_dissolving_stats.append(dissolving_stat)


func _finish_dissolving_cell(dissolving_cell: DissolvingCell) -> void:
	if helper_dissolve_cell.dissolving_cell != dissolving_cell:
		return

	dissolve_delay_timer.stop()

	if dissolving_cell.corresponding_cell != null:
		GLCellManagerBus.emit_signal(
			"delete_selected_collected_cell",
			dissolving_cell.corresponding_cell
		)

	if helper_dissolve_cell.dissolving_cell == dissolving_cell:
		helper_dissolve_cell.dissolving_cell = null

	# Always leave the dissolve state, even if there is no corresponding cell.
	elevator_manager._dissolving_cell_finished()
