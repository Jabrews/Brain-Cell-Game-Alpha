extends Node

# visual components
@onready var bars: Array[Sprite2D] = [
	$"../Stats/Strength/Bar",
	$"../Stats/Intelligence/Bar",
	$"../Stats/Community/Bar"
]

@onready var progress_circles: Array[TextureRect] = [
	$"../Stats/Strength/ProgressCircle",
	$"../Stats/Intelligence/ProgressCircle",
	$"../Stats/Community/ProgressCircle"
]

@onready var threshold_value_left_labels: Array[Label] = [
	$"../Stats/Strength/TresholdValueLeft",
	$"../Stats/Intelligence/TresholdValueLeft",
	$"../Stats/Community/TresholdValueLeft"
]

@onready var disable_parents: Array[Control] = [
	$"../Stats/Strength/Disabled",
	$"../Stats/Intelligence/Disabled",
	$"../Stats/Community/Disabled"
]

# helper components
@onready var helper_display_stat_postions: Node = $HelperDisplayStatPostions


func _ready() -> void:
	
	for bar: Sprite2D in bars:
		bar.material = bar.material.duplicate()
	
	for progress_circle: TextureRect in progress_circles:
		progress_circle.material = progress_circle.material.duplicate()


func _refresh(dissolving_cell: DissolvingCell) -> void:
	
	if dissolving_cell == null:
		return
	
	var dissolving_stats: Array[DissolvingStat] = [
		dissolving_cell.strength_dissolving_stat,
		dissolving_cell.intelligence_dissolving_stat,
		dissolving_cell.community_dissolving_stat
	]
	
	for stat_index: int in range(dissolving_stats.size()):
		
		var dissolving_stat: DissolvingStat = dissolving_stats[stat_index]
		
		var bar: Sprite2D = bars[stat_index]
		var threshold_value_left_label: Label = threshold_value_left_labels[stat_index]
		var progress_circle: TextureRect = progress_circles[stat_index]
		var disabled_parent: Control = disable_parents[stat_index]
		
		
		## DISPLAY
		
		# load into correct position (large, small, medium)
		helper_display_stat_postions._display(
			dissolving_stat,
			bar,
			threshold_value_left_label
		)
		
		_display_bar(
			dissolving_stat,
			bar,
			threshold_value_left_label
		)
		
		progress_circle._display(dissolving_stat)
		
		# disabled
		disabled_parent.visible = (
			dissolving_stat.corresponding_threshold_stat.disabled
		)


func _display_bar(
	dissolving_stat: DissolvingStat,
	bar: Sprite2D,
	threshold_value_left_label: Label
) -> void:
	
	var threshold_stat: ThresholdStat = (
		dissolving_stat.corresponding_threshold_stat
	)
	
	var current_value: float = threshold_stat.current_value
	var max_value: float = threshold_stat.max_value
	var amount_to_decrease: float = dissolving_stat.amount_to_decrease
	
	
	if threshold_stat.disabled or max_value <= 0.0:
		
		threshold_value_left_label.text = ""
		
		bar.material.set_shader_parameter(
			"red_value",
			0.0
		)
		
		bar.material.set_shader_parameter(
			"yellow_value",
			0.0
		)
		
		return
	
	
	threshold_value_left_label.text = str(
		roundi(current_value)
	)
	
	
	# current red position
	var red_shader_value: float = (
		current_value /
		max_value
	)
	
	bar.material.set_shader_parameter(
		"red_value",
		red_shader_value
	)
	
	
	# amount this cell can actually contribute
	var usable_amount: float = maxf(
		amount_to_decrease - dissolving_stat.defect_ignore,
		0.0
	)
	
	var yellow_shader_value: float = (
		usable_amount /
		max_value
	)
	
	bar.material.set_shader_parameter(
		"yellow_value",
		yellow_shader_value
	)
