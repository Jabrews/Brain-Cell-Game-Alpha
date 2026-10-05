extends Node

@onready var goal_tube_inside_mesh: MeshInstance3D = $"../GoalTubeInside"
@onready var update_delay_timer: Timer = $UpdateDelayTimer

var min_goal_progress: float = 0.0
var max_goal_progress: float = 0.25


func _ready() -> void:
	update_delay_timer.one_shot = false
	update_delay_timer.timeout.connect(_handle_update_delay_timer_timeout)


func toggle_update_tube_progress(toggle_value: bool) -> void:
	if toggle_value:
		_update_tube_progress()
		update_delay_timer.start()
	else:
		update_delay_timer.stop()


func _handle_update_delay_timer_timeout() -> void:
	_update_tube_progress()


func _update_tube_progress() -> void:
	var goal_threshold: GoalThreshold = GLGoalThresholdManagerBus.active_goal_threshold
	if goal_threshold == null:
		return

	var threshold_piece: ThresholdPiece = goal_threshold.get_active_piece()
	if threshold_piece == null:
		return

	match goal_threshold.active_piece_index:
		1:
			min_goal_progress = 0.0
			max_goal_progress = 0.25
		2:
			min_goal_progress = 0.25
			max_goal_progress = 0.50
		3:
			min_goal_progress = 0.50
			max_goal_progress = 0.75
		4:
			min_goal_progress = 0.75
			max_goal_progress = 1.0
		_:
			return

	var stats: Array[ThresholdStat] = [
		threshold_piece.strength,
		threshold_piece.intelligence,
		threshold_piece.community
	]

	var total_max: float = 0.0
	var total_remaining: float = 0.0

	for stat: ThresholdStat in stats:
		if stat.disabled:
			continue

		total_max += stat.max_value
		total_remaining += clampf(stat.current_value, 0.0, stat.max_value)

	var piece_progress: float = 0.0
	if total_max > 0.0:
		piece_progress = 1.0 - (total_remaining / total_max)

	var yellow_fill: float = lerpf(
		min_goal_progress,
		max_goal_progress,
		piece_progress
	)

	var tube_material := goal_tube_inside_mesh.get_active_material(0) as ShaderMaterial
	if tube_material == null:
		push_warning("GoalTubeInside surface 0 does not have a ShaderMaterial.")
		return

	tube_material.set_shader_parameter("yellow_fill", yellow_fill)
