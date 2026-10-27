extends Node

# Components
@onready var accept_cell_parent: Control = $"../AcceptCell"
@onready var helper_display_stat_positions: Node = $HelperDisplayStatPositions

# Threshold stats
@onready var threshold_bars: Array[Sprite2D] = [
	$"../AcceptCell/Stats/Strength/Bar",
	$"../AcceptCell/Stats/Intelligence/Bar",
	$"../AcceptCell/Stats/Community/Bar"
]

@onready var threshold_disabled_parents: Array[Control] = [
	$"../AcceptCell/Stats/Strength/Disabled",
	$"../AcceptCell/Stats/Intelligence/Disabled",
	$"../AcceptCell/Stats/Community/Disabled"
]

# Defect-ignored state parents
@onready var d_i_default_parents: Array[Control] = [
	$"../AcceptCell/DefectIgnored/Strength/Default",
	$"../AcceptCell/DefectIgnored/Intelligence/Default",
	$"../AcceptCell/DefectIgnored/Community/Default"
]

@onready var d_i_hidden_parents: Array[Control] = [
	$"../AcceptCell/DefectIgnored/Strength/Hidden",
	$"../AcceptCell/DefectIgnored/Intelligence/Hidden",
	$"../AcceptCell/DefectIgnored/Community/Hidden"
]

@onready var d_i_disabled_parents: Array[Control] = [
	$"../AcceptCell/DefectIgnored/Strength/Disabled",
	$"../AcceptCell/DefectIgnored/Intelligence/Disabled",
	$"../AcceptCell/DefectIgnored/Community/Disabled"
]

# Defect-ignored default-state components
@onready var d_i_ignored_percent_labels: Array[Label] = [
	$"../AcceptCell/DefectIgnored/Strength/Default/IgnoredPercant",
	$"../AcceptCell/DefectIgnored/Intelligence/Default/IgnoredPercant",
	$"../AcceptCell/DefectIgnored/Community/Default/IgnoredPercant"
]

@onready var d_i_clean_bars: Array[Sprite2D] = [
	$"../AcceptCell/DefectIgnored/Strength/Default/Stats/CleanBar",
	$"../AcceptCell/DefectIgnored/Intelligence/Default/Stats/CleanBar",
	$"../AcceptCell/DefectIgnored/Community/Default/Stats/CleanBar"
]

@onready var d_i_defect_bars: Array[Sprite2D] = [
	$"../AcceptCell/DefectIgnored/Strength/Default/Stats/DefectBar",
	$"../AcceptCell/DefectIgnored/Intelligence/Default/Stats/DefectBar",
	$"../AcceptCell/DefectIgnored/Community/Default/Stats/DefectBar"
]

var ignored_label_warning_tweens: Dictionary = {}


func _ready() -> void:
	for threshold_bar: Sprite2D in threshold_bars:
		threshold_bar.material = threshold_bar.material.duplicate()

	for clean_bar: Sprite2D in d_i_clean_bars:
		clean_bar.material = clean_bar.material.duplicate()

	for defect_bar: Sprite2D in d_i_defect_bars:
		defect_bar.material = defect_bar.material.duplicate()


#### Show ####

func show_accept_cell_screen(elevator_cell: BrainCell) -> void:
	if not elevator_cell:
		push_error("Attempted to show accept-cell screen without a cell.")
		return

	var stats: Array[BrainCellStat] = [
		elevator_cell.strength,
		elevator_cell.intelligence,
		elevator_cell.community
	]

	var threshold_piece: ThresholdPiece = (
		GLGoalThresholdManagerBus.active_goal_threshold.get_active_piece()
	)

	for stat_index: int in range(stats.size()):
		var stat: BrainCellStat = stats[stat_index]
		var threshold_stat: ThresholdStat = threshold_piece.get_stat(stat.type)

		if threshold_stat == null:
			continue

		var threshold_bar: Sprite2D = threshold_bars[stat_index]
		var threshold_disabled_parent: Control = threshold_disabled_parents[stat_index]

		helper_display_stat_positions._display(threshold_stat, threshold_bar)

		_display_threshold_bars(
			stat,
			threshold_stat,
			threshold_bar,
			threshold_disabled_parent
		)

		_display_defect_ignored(
			stat,
			threshold_stat,
			d_i_default_parents[stat_index],
			d_i_hidden_parents[stat_index],
			d_i_disabled_parents[stat_index],
			d_i_ignored_percent_labels[stat_index],
			d_i_clean_bars[stat_index],
			d_i_defect_bars[stat_index]
		)

	accept_cell_parent.visible = true


func _display_threshold_bars(
	stat: BrainCellStat,
	threshold_stat: ThresholdStat,
	threshold_bar: Sprite2D,
	threshold_disabled_parent: Control
) -> void:
	var material: ShaderMaterial = threshold_bar.material

	threshold_disabled_parent.visible = threshold_stat.disabled

	# Clear old preview values.
	material.set_shader_parameter("current_value", 0.0)
	material.set_shader_parameter("dissolve_value", 0.0)
	material.set_shader_parameter("defect_value", 0.0)

	var max_value: float = threshold_stat.max_value

	if threshold_stat.disabled or max_value <= 0.0:
		return

	var current_value: float = clampf(
		threshold_stat.current_value,
		0.0,
		max_value
	)

	material.set_shader_parameter(
		"current_value",
		current_value / max_value
	)

	if not stat.enabled or stat.hidden:
		return

	# The contribution is the raw stat value; defect is striped within it.
	var visible_contribution: float = minf(
		maxf(stat.value, 0.0),
		current_value
	)
	var visible_defect: float = minf(
		maxf(stat.defect, 0.0),
		visible_contribution
	)

	material.set_shader_parameter(
		"dissolve_value",
		visible_contribution / max_value
	)
	material.set_shader_parameter(
		"defect_value",
		visible_defect / max_value
	)


func _display_defect_ignored(
	stat: BrainCellStat,
	threshold_stat: ThresholdStat,
	default_parent: Control,
	hidden_parent: Control,
	disabled_parent: Control,
	ignored_percent_label: Label,
	clean_bar: Sprite2D,
	defect_bar: Sprite2D
) -> void:
	_stop_ignored_label_warning(ignored_percent_label)

	# Hide all states first so only one can be shown.
	default_parent.visible = false
	hidden_parent.visible = false
	disabled_parent.visible = false

	# A disabled threshold shows none of the defect-ignored states.
	if threshold_stat.disabled:
		return

	if not stat.enabled:
		disabled_parent.visible = true
		return

	if stat.hidden:
		hidden_parent.visible = true
		return

	default_parent.visible = true

	var ignored_percent: float = 0.0
	if stat.value > 0.0:
		ignored_percent = clampf(
			stat.defect / stat.value * 100.0,
			0.0,
			100.0
		)

	ignored_percent_label.text = str(int(ignored_percent)) + "%"

	if ignored_percent > 75.0:
		_start_ignored_label_warning(ignored_percent_label)

	var max_value: float = IVCellCreator.max_stat_value
	if max_value <= 0.0:
		push_error("max_stat_value must be greater than 0.")
		return

	var prisoner_value: float = clampf(stat.value / max_value, 0.0, 1.0)
	var defect_value: float = clampf(stat.defect / max_value, 0.0, 1.0)

	clean_bar.material.set_shader_parameter("prisoner_value", prisoner_value)
	clean_bar.material.set_shader_parameter("flash_value", defect_value)
	defect_bar.material.set_shader_parameter("defect_value", defect_value)


func _start_ignored_label_warning(label: Label) -> void:
	label.pivot_offset = label.size * 0.5

	var tween: Tween = create_tween().set_loops()
	ignored_label_warning_tweens[label] = tween

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(label, "modulate:a", 0.25, 0.25)
	tween.parallel().tween_property(label, "scale", Vector2(1.2, 1.2), 0.25)

	tween.tween_property(label, "modulate:a", 1.0, 0.25)
	tween.parallel().tween_property(label, "scale", Vector2.ONE, 0.25)


func _stop_ignored_label_warning(label: Label) -> void:
	var tween: Tween = ignored_label_warning_tweens.get(label)

	if tween and tween.is_running():
		tween.kill()

	ignored_label_warning_tweens.erase(label)
	label.modulate.a = 1.0
	label.scale = Vector2.ONE


#### Hide ####

func hide_accept_cell_screen() -> void:
	accept_cell_parent.visible = false
