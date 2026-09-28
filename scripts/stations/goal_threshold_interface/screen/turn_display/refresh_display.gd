extends Node


# components
@onready var turns_left_label : Label = $"../CurrentTurnsLeft/TurnsLeftLabel"

@onready var reward_parent : Control = $"../Reward"
@onready var reward_energy_label : Label = $"../Reward/EnergyReward/HeaderLabel"
@onready var reward_turns_left_label : Label = $"../Reward/TurnsLeft/TurnsLeftLabel"

@onready var reward_completed_parent : Control = $"../RewardCompleted"
@onready var reward_failed_parent : Control = $"../RewardFailed"


# low turns tween
var turns_left_label_org_pos : Vector2
var low_turns_tween : Tween

@export var low_turns_move_amount : float = 4.0
@export var low_turns_tween_time : float = 0.18


# reward 0 tween
var reward_turns_left_label_org_pos : Vector2
var reward_zero_tween : Tween

@export var reward_shake_amount : float = 5.0
@export var reward_shake_time : float = 0.5


func _ready() -> void:
	turns_left_label_org_pos = turns_left_label.global_position
	reward_turns_left_label_org_pos = reward_turns_left_label.global_position


func _refresh() -> void:
	
	var active_goal_threshold : GoalThreshold = GLGoalThresholdManagerBus.active_goal_threshold
	var active_threshold_piece : ThresholdPiece = active_goal_threshold.get_active_piece()
	
	toggle_low_turns_tween(false)
	
	turns_left_label.text = str(active_threshold_piece.turns_remaining)
	
	
	# low turns warning
	if active_threshold_piece.turns_remaining <= 1:
		toggle_low_turns_tween(true)
	
	
	handle_complete_early_reward(active_threshold_piece)


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


func handle_complete_early_reward(
	active_threshold_piece : ThresholdPiece
) -> void:
	
	reward_parent.visible = false
	reward_completed_parent.visible = false
	reward_failed_parent.visible = false
	
	
	# already claimed
	if active_threshold_piece.early_reward_claimed:
		reward_completed_parent.visible = true
		return
	
	
	# find how many turns used
	var turns_used : int = (
		active_threshold_piece.total_turns -
		active_threshold_piece.turns_remaining
	)
	
	
	# already failed
	if turns_used >= active_threshold_piece.early_completion_turn_limit + 1:
		reward_failed_parent.visible = true
		return
	
	
	# reward still available
	reward_parent.visible = true
	
	reward_energy_label.text = "+" + str(
		active_threshold_piece.early_completion_reward_energy
	)
	
	
	# turns left before reward expires
	var reward_turns_remaining : int = (
		active_threshold_piece.early_completion_turn_limit -
		turns_used
	)
	
	reward_turns_left_label.text = str(reward_turns_remaining)
	
	
	# short shake when reward reaches 0
	if reward_turns_remaining == 0:
		play_reward_zero_tween()


func play_reward_zero_tween() -> void:
	
	if reward_zero_tween:
		reward_zero_tween.kill()
		reward_zero_tween = null
	
	
	reward_turns_left_label.global_position = reward_turns_left_label_org_pos
	
	reward_zero_tween = create_tween()
	reward_zero_tween.set_loops()	
	
	
	# slightly up
	reward_zero_tween.tween_property(
		reward_turns_left_label,
		"global_position:y",
		reward_turns_left_label_org_pos.y - reward_shake_amount,
		reward_shake_time
	)
	
	
	# slightly down
	reward_zero_tween.tween_property(
		reward_turns_left_label,
		"global_position:y",
		reward_turns_left_label_org_pos.y + reward_shake_amount,
		reward_shake_time
	)
	
	
	# return to original position
	reward_zero_tween.tween_property(
		reward_turns_left_label,
		"global_position:y",
		reward_turns_left_label_org_pos.y,
		reward_shake_time
	)
