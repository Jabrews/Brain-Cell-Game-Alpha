extends Node

## Parent components
@onready var failure_chance_parent: Control = $FailureChance
@onready var disabled_parent: Control = $Disabled
@onready var stat_invalid_parent: Control = $StatInvalid

## Failure chance components
@onready var defect_bar: TextureProgressBar = $FailureChance/DefectBar/DefectBar
@onready var failure_chance_percent_label: Label = $FailureChance/PercantLabel
@onready var loading_parent: Control = $Loading

## Failure chance warning
var label_original_position: Vector2

var tier_one_tween: Tween
var tier_two_tween: Tween

const TIER_ONE_FLOAT_DISTANCE: float = 2.0
const TIER_ONE_FLOAT_SPEED: float = 2.0
const TIER_ONE_SCALE: Vector2 = Vector2(1.05, 1.05)
const TIER_ONE_SCALE_SPEED: float = 2.0

const TIER_TWO_FLOAT_DISTANCE: float = 4.0
const TIER_TWO_FLOAT_SPEED: float = 4.0
const TIER_TWO_SCALE: Vector2 = Vector2(1.25, 1.25)
const TIER_TWO_SCALE_SPEED: float = 5.0


func _ready() -> void:
	label_original_position = failure_chance_percent_label.position
	failure_chance_percent_label.pivot_offset = (
		failure_chance_percent_label.size / 2.0
	)


func _refresh(
	enabled: bool,
	loaded_cell: BrainCell,
	stat_valid: bool,
	selected_stat: String,
	failure_rate: int
) -> void:
	failure_chance_parent.visible = false
	disabled_parent.visible = false
	stat_invalid_parent.visible = false
	loading_parent.visible = false

	# Stop any warning animation before refreshing the display.
	_set_tier_one_warning_visible(false)
	_set_tier_two_warning_visible(false)
	_reset_warning_visuals()

	if not enabled or not loaded_cell:
		disabled_parent.visible = true
		return

	if not stat_valid:
		stat_invalid_parent.visible = true
		return

	loading_parent.visible = true
	display_failure_chance(loaded_cell, selected_stat, failure_rate)

	await get_tree().create_timer(0.5).timeout

	loading_parent.visible = false
	failure_chance_parent.visible = true


func display_failure_chance(
	loaded_cell: BrainCell,
	selected_stat: String,
	failure_rate: int
) -> void:
	var stat: BrainCellStat = loaded_cell.get_stat(selected_stat)

	if not stat:
		push_error("Cannot find stat: " + selected_stat)
		return

	var max_stat_value: float = IVCellCreator.max_stat_value

	defect_bar.max_value = max_stat_value
	defect_bar.value = stat.defect
	failure_chance_percent_label.text = str(failure_rate) + "%"

	# Tier one warning.
	if failure_rate > 25 and failure_rate <= 50:
		_set_tier_one_warning_visible(true)
	# Tier two warning.
	elif failure_rate > 50:
		_set_tier_two_warning_visible(true)


func _reset_warning_visuals() -> void:
	failure_chance_percent_label.position = label_original_position
	failure_chance_percent_label.scale = Vector2.ONE
	defect_bar.material.set_shader_parameter("flash_enabled", false)


func _set_tier_one_warning_visible(visible: bool) -> void:
	if tier_one_tween and tier_one_tween.is_running():
		tier_one_tween.kill()

	if visible:
		tier_one_tween = _create_warning_tween(
			TIER_ONE_FLOAT_DISTANCE,
			TIER_ONE_FLOAT_SPEED,
			TIER_ONE_SCALE,
			TIER_ONE_SCALE_SPEED
		)


func _set_tier_two_warning_visible(visible: bool) -> void:
	if tier_two_tween and tier_two_tween.is_running():
		tier_two_tween.kill()

	defect_bar.material.set_shader_parameter("flash_enabled", visible)

	if visible:
		tier_two_tween = _create_warning_tween(
			TIER_TWO_FLOAT_DISTANCE,
			TIER_TWO_FLOAT_SPEED,
			TIER_TWO_SCALE,
			TIER_TWO_SCALE_SPEED
		)


func _create_warning_tween(
	float_distance: float,
	float_speed: float,
	target_scale: Vector2,
	scale_speed: float
) -> Tween:
	var tween: Tween = create_tween().set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	var float_duration: float = 1.0 / float_speed
	var scale_duration: float = 1.0 / scale_speed

	tween.tween_property(
		failure_chance_percent_label,
		"position:y",
		label_original_position.y - float_distance,
		float_duration
	)
	tween.parallel().tween_property(
		failure_chance_percent_label,
		"scale",
		target_scale,
		scale_duration
	)

	tween.tween_property(
		failure_chance_percent_label,
		"position:y",
		label_original_position.y,
		float_duration
	)
	tween.parallel().tween_property(
		failure_chance_percent_label,
		"scale",
		Vector2.ONE,
		scale_duration
	)

	return tween
