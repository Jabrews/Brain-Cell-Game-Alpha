
extends Node

# Components
@onready var total_chance_label: Label = $"../../../../AttacherUI/StatMainView/FailureChanceView/TotalChanceLabel"


# Phase thresholds
@export_group("Phase Thresholds")
@export_range(0, 100) var slight_threshold: int = 25
@export_range(0, 100) var moderate_threshold: int = 50
@export_range(0, 100) var extreme_threshold: int = 80


# Phase 1: Slight
@export_group("Phase 1 - Slight")
@export var slight_movement: float = 3.0
@export var slight_duration: float = 0.5


# Phase 2: Moderate
@export_group("Phase 2 - Moderate")
@export var moderate_movement: float = 6.0
@export var moderate_duration: float = 0.35
@export_range(0.0, 1.0) var moderate_min_opacity: float = 0.5


# Phase 3: Extreme
@export_group("Phase 3 - Extreme")
@export var extreme_movement: float = 1.0
@export var extreme_duration: float = 0.2
@export_range(0.0, 1.0) var extreme_min_opacity: float = 0.2
@export var extreme_scale: float = 0.90


# Animation
var animation_tween: Tween
var current_phase: int = -1
var original_position: Vector2

const NORMAL_SCALE: Vector2 = Vector2.ONE


func _ready() -> void:
	original_position = total_chance_label.position

	total_chance_label.resized.connect(_update_pivot)
	_update_pivot()


func _refresh(loaded_cell: BrainCell) -> void:
	if not loaded_cell:
		total_chance_label.text = "0%"
		_set_animation_phase(0)
		return

	var total_failure_chance: int = GAMEFailureChance.attacher_helper._get_total_failure_chance(
		loaded_cell,
		GLAttacherComponentBus.main_stat_replacement_failure_penality,
		GLAttacherComponentBus.main_stat_replacement_state
	)

	total_chance_label.text = str(total_failure_chance) + "%"

	var new_phase: int = 0

	if total_failure_chance >= extreme_threshold:
		new_phase = 3
	elif total_failure_chance >= moderate_threshold:
		new_phase = 2
	elif total_failure_chance >= slight_threshold:
		new_phase = 1

	_set_animation_phase(new_phase)


func _set_animation_phase(phase: int) -> void:
	if current_phase == phase:
		return

	current_phase = phase
	_stop_animation()

	match phase:
		1:
			_animate_slight()
		2:
			_animate_moderate()
		3:
			_animate_extreme()


func _stop_animation() -> void:
	if animation_tween and animation_tween.is_running():
		animation_tween.kill()

	total_chance_label.position = original_position
	total_chance_label.scale = NORMAL_SCALE
	total_chance_label.modulate.a = 1.0


func _update_pivot() -> void:
	total_chance_label.pivot_offset = total_chance_label.size / 2.0


# Phase 1: Slight horizontal movement
func _animate_slight() -> void:
	animation_tween = create_tween().set_loops()
	animation_tween.set_trans(Tween.TRANS_SINE)
	animation_tween.set_ease(Tween.EASE_IN_OUT)

	animation_tween.tween_property(
		total_chance_label,
		"position:x",
		original_position.x - slight_movement,
		slight_duration
	)

	animation_tween.tween_property(
		total_chance_label,
		"position:x",
		original_position.x + slight_movement,
		slight_duration * 2.0
	)

	animation_tween.tween_property(
		total_chance_label,
		"position:x",
		original_position.x,
		slight_duration
	)


# Phase 2: Moderate movement + opacity
func _animate_moderate() -> void:
	animation_tween = create_tween().set_loops()
	animation_tween.set_trans(Tween.TRANS_SINE)
	animation_tween.set_ease(Tween.EASE_IN_OUT)

	animation_tween.tween_property(
		total_chance_label,
		"position:x",
		original_position.x - moderate_movement,
		moderate_duration
	)

	animation_tween.parallel().tween_property(
		total_chance_label,
		"modulate:a",
		moderate_min_opacity,
		moderate_duration
	)

	animation_tween.tween_property(
		total_chance_label,
		"position:x",
		original_position.x + moderate_movement,
		moderate_duration * 2.0
	)

	animation_tween.parallel().tween_property(
		total_chance_label,
		"modulate:a",
		1.0,
		moderate_duration * 2.0
	)

	animation_tween.tween_property(
		total_chance_label,
		"position:x",
		original_position.x,
		moderate_duration
	)


# Phase 3: Extreme movement + blinking + scaling
func _animate_extreme() -> void:
	animation_tween = create_tween().set_loops()
	animation_tween.set_trans(Tween.TRANS_SINE)
	animation_tween.set_ease(Tween.EASE_IN_OUT)

	animation_tween.tween_property(
		total_chance_label,
		"position:x",
		original_position.x - extreme_movement,
		extreme_duration
	)

	animation_tween.parallel().tween_property(
		total_chance_label,
		"modulate:a",
		extreme_min_opacity,
		extreme_duration
	)

	animation_tween.parallel().tween_property(
		total_chance_label,
		"scale",
		Vector2.ONE * extreme_scale,
		extreme_duration
	)

	animation_tween.tween_property(
		total_chance_label,
		"position:x",
		original_position.x + extreme_movement,
		extreme_duration * 2.0
	)

	animation_tween.parallel().tween_property(
		total_chance_label,
		"modulate:a",
		1.0,
		extreme_duration * 2.0
	)

	animation_tween.parallel().tween_property(
		total_chance_label,
		"scale",
		NORMAL_SCALE,
		extreme_duration * 2.0
	)

	animation_tween.tween_property(
		total_chance_label,
		"position:x",
		original_position.x,
		extreme_duration
	)
