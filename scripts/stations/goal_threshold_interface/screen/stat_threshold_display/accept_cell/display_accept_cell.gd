extends Node

# components
@onready var accept_cell_parent : Control = $"../AcceptCell"
@onready var helper_display_stat_positions : Node = $HelperDisplayStatPositions

# visual components
@onready var threshold_bars : Array[Sprite2D] = [
	$"../AcceptCell/Stats/Strength/Bar", $"../AcceptCell/Stats/Intelligence/Bar", $"../AcceptCell/Stats/Community/Bar"
]
@onready var threshold_disabled_parents : Array[Control] = [
	$"../AcceptCell/Stats/Strength/Disabled", $"../AcceptCell/Stats/Intelligence/Disabled", $"../AcceptCell/Stats/Community/Disabled"
]

@onready var defect_ignored_percant_labels : Array[Label] = [
	$"../AcceptCell/DefectIgnored/Strength/IgnoredPercant/IgnoredPercant",
	$"../AcceptCell/DefectIgnored/Intelligence/IgnoredPercant/IgnoredPercant",
	$"../AcceptCell/DefectIgnored/Community/IgnoredPercant/IgnoredPercant",
]
@onready var defect_ignored_percant_parent :Array[Control] = [
	$"../AcceptCell/DefectIgnored/Strength/IgnoredPercant",
	$"../AcceptCell/DefectIgnored/Intelligence/IgnoredPercant",
	$"../AcceptCell/DefectIgnored/Community/IgnoredPercant",
	
]
@onready var defect_ignored_clean_bars : Array[Sprite2D] = [
	$"../AcceptCell/DefectIgnored/Strength/IgnoredPercant/Stats/CleanBar",
	$"../AcceptCell/DefectIgnored/Intelligence/IgnoredPercant/Stats/CleanBar",
	$"../AcceptCell/DefectIgnored/Community/IgnoredPercant/Stats/CleanBar",
]
@onready var defect_ignored_defect_bars : Array[Sprite2D] = [
	$"../AcceptCell/DefectIgnored/Strength/IgnoredPercant/Stats/DefectBar",
	$"../AcceptCell/DefectIgnored/Intelligence/IgnoredPercant/Stats/DefectBar",
	$"../AcceptCell/DefectIgnored/Community/IgnoredPercant/Stats/DefectBar",
]


@onready var defect_ignored_disabled_parents : Array[Control] = [
	$"../AcceptCell/DefectIgnored/Strength/Disabled",
	$"../AcceptCell/DefectIgnored/Intelligence/Disabled",
	$"../AcceptCell/DefectIgnored/Community/Disabled"
]
@onready var defect_ignored_hidden_parents : Array[Control] = [
	$"../AcceptCell/DefectIgnored/Strength/Hidden",
	$"../AcceptCell/DefectIgnored/Intelligence/Hidden",
	$"../AcceptCell/DefectIgnored/Community/Hidden"
]


func _ready() -> void:
	for threshold_bar : Sprite2D in threshold_bars : 
		threshold_bar.material = threshold_bar.material.duplicate()
	
	for clean_bar : Sprite2D in defect_ignored_clean_bars :
		clean_bar.material = clean_bar.material.duplicate()
		
	for defect_bar : Sprite2D in defect_ignored_defect_bars:
		defect_bar.material = defect_bar.material.duplicate()


#### SHOW ####

func show_accept_cell_screen(elevator_cell : BrainCell) :
	
	if not elevator_cell : 
		push_error('attempting to show accept cell screen without cell')
		return
	
	
	var stats : Array[BrainCellStat] = []
	stats.append(elevator_cell.strength)
	stats.append(elevator_cell.intelligence)
	stats.append(elevator_cell.community)
	
	var curr_threshold_piece : ThresholdPiece = GLGoalThresholdManagerBus.active_goal_threshold.get_active_piece()
	
	for stat_index in stats.size():
		var stat: BrainCellStat = stats[stat_index]
		var threshold_stat: ThresholdStat = curr_threshold_piece.get_stat(stat.type)

		if threshold_stat == null:
			continue

		# Threshold display
		var threshold_bar: Sprite2D = threshold_bars[stat_index]
		var threshold_disabled_parent: Control = threshold_disabled_parents[stat_index]
		
		# load proper threshold bar postions
		helper_display_stat_positions._display(threshold_stat, threshold_bar)

		# Defect ignored display
		var ignored_percent_label: Label = defect_ignored_percant_labels[stat_index]
		var ignored_clean_bar: Sprite2D = defect_ignored_clean_bars[stat_index]
		var ignored_defect_bar: Sprite2D = defect_ignored_defect_bars[stat_index]
		var ignored_disabled_parent: Control = defect_ignored_disabled_parents[stat_index]
		var ignored_hidden_parent: Control = defect_ignored_hidden_parents[stat_index]
		var ignored_percant_parent : Control = defect_ignored_percant_parent[stat_index]
		

		# load correct postion of bar
		_display_threshold_bars(stat, threshold_stat, threshold_bar, threshold_disabled_parent)
		
		_display_defect_ignored_percant(stat, threshold_stat, ignored_percent_label, ignored_percant_parent, ignored_disabled_parent, ignored_hidden_parent)
		
		_display_defect_ignored_bars(stat, threshold_stat, ignored_clean_bar, ignored_defect_bar)
		
		
		
	
	
	
	
	accept_cell_parent.visible = true


func _display_threshold_bars(
	stat: BrainCellStat,
	threshold_stat: ThresholdStat,
	threshold_bar: Sprite2D,
	threshold_disabled_parent: Control,
) -> void:
	
	var amount_to_decrease : float = max(0, stat.value - stat.defect)
	var defect_ignore : float = stat.defect
	
	var material: ShaderMaterial = threshold_bar.material

	threshold_disabled_parent.visible = threshold_stat.disabled

	# Clear old preview values.
	material.set_shader_parameter("current_value", 0.0)
	material.set_shader_parameter("dissolve_value", 0.0)
	material.set_shader_parameter("defect_value", 0.0)

	var max_value: float = threshold_stat.max_value

	if threshold_stat.disabled or max_value <= 0.0:
		return

	var current_value: float = maxf(threshold_stat.current_value, 0.0)

	# Always show the threshold's current value.
	material.set_shader_parameter(
		"current_value",
		clampf(current_value / max_value, 0.0, 1.0)
	)

	# Hidden or disabled cell stats should not reveal a preview.
	if not stat.enabled or stat.hidden:
		return

	var full_amount: float = maxf(amount_to_decrease, 0.0)
	var usable_amount: float = maxf(
		full_amount - maxf(defect_ignore, 0.0),
		0.0
	)

	# Only show amounts that affect the remaining threshold.
	var visible_full_amount: float = minf(full_amount, current_value)
	var visible_usable_amount: float = minf(usable_amount, current_value)
	var visible_blocked_amount: float = (
		visible_full_amount - visible_usable_amount
	)

	material.set_shader_parameter(
		"dissolve_value",
		visible_full_amount / max_value
	)

	material.set_shader_parameter(
		"defect_value",
		visible_blocked_amount / max_value
	)
	

func _display_defect_ignored_percant(
	stat : BrainCellStat, 
	threshold_stat : ThresholdStat,
	ignored_percent_label : Label,
	ignored_percant_parent : Control,
	ignored_disabled_parent : Control,
	ignored_hidden_parent : Control
) :
	
	ignored_percent_label.visible = false	
	ignored_percant_parent.visible = false
	ignored_disabled_parent.visible = false
	ignored_hidden_parent.visible = false
	
	if stat.enabled == false or threshold_stat.disabled: 
		ignored_disabled_parent.visible  = true
		return
		
	if stat.hidden : 
		ignored_hidden_parent.visible = true
		return
	
	ignored_percant_parent.visible = true
	ignored_percent_label.visible = true
	
	# TODO set ignored percant label
	ignored_percent_label.text = str('')
	

func _display_defect_ignored_bars(
	stat : BrainCellStat,
	threshold_stat : ThresholdStat,
	ignored_clean_bar : Sprite2D,
	ignored_defect_bar : Sprite2D
) :
	ignored_clean_bar.visible = false	
	ignored_defect_bar.visible = false
	
	if stat.hidden or stat.enabled == false or threshold_stat.disabled: 
		return
	
	ignored_clean_bar.visible = true
	ignored_defect_bar.visible = true
	
	# TODO
	ignored_clean_bar.material.set_shader_parameter("prisoner_value", 0)
	ignored_clean_bar.material.set_shader_parameter("flash_value", 0)
	
	ignored_clean_bar.material.set_shader_parameter("defect_value", 0)
	
		




#### HIDE #####

func hide_accept_cell_screen() :
	accept_cell_parent.visible = false 
