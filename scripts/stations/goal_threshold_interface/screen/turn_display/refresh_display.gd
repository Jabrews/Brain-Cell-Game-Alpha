extends Node


# components
@onready var turns_left_label : Label = $"../CurrentTurnsLeft/TurnsLeftLabel"


# low turns tween
var turns_left_label_org_pos : Vector2
var low_turns_tween : Tween

@export var low_turns_move_amount : float = 4.0
@export var low_turns_tween_time : float = 0.18


func _ready() -> void:
	turns_left_label_org_pos = turns_left_label.global_position


func _refresh() -> void:
	
	var active_goal_threshold : GoalThreshold = GLGoalThresholdManagerBus.active_goal_threshold
	var active_threshold_piece : ThresholdPiece = active_goal_threshold.get_active_piece()
	
	toggle_low_turns_tween(false)
	
	turns_left_label.text = str(active_threshold_piece.turns_remaining)
	
	
	# low turns warning
	if active_threshold_piece.turns_remaining <= 1:
		toggle_low_turns_tween(true)


func toggle_low_turns_tween(toggle_value : bool) -> void:
	
	if low_turns_tween:
		low_turns_tween.kill()
		low_turns_tween = null
	
	
	if not toggle_value:
		turns_left_label.global_position = turns_left_label_org_pos
		turns_left_label.modulate = Color.WHITE
		return
	
	
	turns_left_label.global_position = turns_left_label_org_pos
	turns_left_label.modulate = Color.WHITE
	
	low_turns_tween = create_tween()
	low_turns_tween.set_loops()
	
	
	# move up + red
	low_turns_tween.tween_property(
		turns_left_label,
		"global_position:y",
		turns_left_label_org_pos.y - low_turns_move_amount,
		low_turns_tween_time
	)
	
	low_turns_tween.parallel().tween_property(
		turns_left_label,
		"modulate",
		Color.RED,
		low_turns_tween_time
	)
	
	
	# move down + white
	low_turns_tween.tween_property(
		turns_left_label,
		"global_position:y",
		turns_left_label_org_pos.y + low_turns_move_amount,
		low_turns_tween_time
	)
	
	low_turns_tween.parallel().tween_property(
		turns_left_label,
		"modulate",
		Color.WHITE,
		low_turns_tween_time
	)
	
	
	# return center
	low_turns_tween.tween_property(
		turns_left_label,
		"global_position:y",
		turns_left_label_org_pos.y,
		low_turns_tween_time
	)
