extends Node

const STAT_TYPES: Array[String] = [
	"strength",
	"intelligence",
	"community",
]

@export var debuff_amount: float = 5.0

@onready var defect_bars: Array[Sprite2D] = [
	$"../../../StatDisplay/DefectBars/DefectStrengthBar",
	$"../../../StatDisplay/DefectBars/DefectIntelligenceBar",
	$"../../../StatDisplay/DefectBars/DefectCommunityBar"
]

@onready var progress_bars: Array[Sprite2D] = [
	$"../../../StatDisplay/ProgressBars/StrengthBar",
	$"../../../StatDisplay/ProgressBars/IntelligenceBar",
	$"../../../StatDisplay/ProgressBars/CommunityBar"
]

var active_brain_cell: BrainCell


func set_active_cell(brain_cell: BrainCell) -> void:
	active_brain_cell = brain_cell


func _handle_preview_debuff(cycled_stat: String) -> void:
	if active_brain_cell == null:
		return

	var max_value: float = float(IVCellCreator.max_stat_value)

	for i: int in range(STAT_TYPES.size()):
		var stat_type: String = STAT_TYPES[i]
		var cell_stat: BrainCellStat = active_brain_cell.get(stat_type)

		var old_defect_value: float = cell_stat.defect
		var new_defect_value: float = old_defect_value

		if stat_type == cycled_stat:
			new_defect_value = clamp(
				old_defect_value + debuff_amount,
				0.0,
				max_value
			)

		defect_bars[i].material.set_shader_parameter(
			"prior_defect_value",
			old_defect_value / max_value
		)

		defect_bars[i].material.set_shader_parameter(
			"new_defect_value",
			new_defect_value / max_value
		)
