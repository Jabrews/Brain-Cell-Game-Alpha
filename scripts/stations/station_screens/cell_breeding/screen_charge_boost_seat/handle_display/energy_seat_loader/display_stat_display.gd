extends Node

const STAT_TYPES: Array[String] = [
	"strength",
	"intelligence",
	"community",
]

# components
@onready var cell_name_label : Label = $"../../../StatDisplay/CellName"
@onready var defect_bars: Array[Sprite2D] = [
	$"../../../StatDisplay/DefectBars/DefectStrengthBar",
	$"../../../StatDisplay/DefectBars/DefectIntelligenceBar",
	$"../../../StatDisplay/DefectBars/DefectCommunityBar"
]
@onready var clean_bars : Array[Sprite2D] = [
	$"../../../StatDisplay/ProgressBars/StrengthBar",
	$"../../../StatDisplay/ProgressBars/IntelligenceBar",
	$"../../../StatDisplay/ProgressBars/CommunityBar"
]
@onready var clean_stat_labels : Array[Label] = [
	$"../../../StatDisplay/ProgressBars/StengthLabel",
	$"../../../StatDisplay/ProgressBars/IntelligenceLabel",
	$"../../../StatDisplay/ProgressBars/CommunityLabel"
]
@onready var hide_stat_sprites : Array[Sprite2D] = [
	$"../../../StatDisplay/HideStats/StrengthHide",
	$"../../../StatDisplay/HideStats/IntelligenceHide",
	$"../../../StatDisplay/HideStats/CommunityHide"
]
@onready var off_labels : Array[Label] = [
	$"../../../StatDisplay/OffLabels/StrengthOffLabel",
	$"../../../StatDisplay/OffLabels/IntelligenceOffLabel",
	$"../../../StatDisplay/OffLabels/CommunityOffLabel"
]

func _ready() -> void:
	for clean_bar: Sprite2D in clean_bars:
		clean_bar.material = clean_bar.material.duplicate()
	
	for defect_bar : Sprite2D in defect_bars : 
		defect_bar.material = defect_bar.material.duplicate()


func _display_cell(brain_cell: BrainCell) -> void:
	if brain_cell == null:
		return
		
	display(brain_cell,)


func display(brain_cell: BrainCell) -> void:
	var target_cell: BrainCell = GLCellManagerBus.target_cell_refrence
	var max_value: float = float(IVCellCreator.max_stat_value)

	cell_name_label.text = str(brain_cell.name)

	for i: int in STAT_TYPES.size():
		var stat_type: String = STAT_TYPES[i]

		var cell_stat: BrainCellStat = brain_cell.get(stat_type)
		var target_stat: BrainCellStat = target_cell.get(stat_type)

		if not cell_stat.enabled:
			_display_disabled_stat(i)
			continue

		_display_hidden_stat(i, cell_stat)
		_display_defect_stat(i, cell_stat)
		_display_clean_stat(i, cell_stat, target_stat, max_value)





func _display_disabled_stat(
	index: int,
) -> void:
	off_labels[index].visible = true
	clean_stat_labels[index].modulate.a = 0.4


func _display_hidden_stat(
	index: int,
	cell_stat: BrainCellStat,
) -> void:
	hide_stat_sprites[index].visible = cell_stat.hidden


func _display_defect_stat(
	index: int,
	cell_stat: BrainCellStat,
) -> void:
	
	var max_value : float = IVCellCreator.max_stat_value
	
	defect_bars[index].material.set_shader_parameter("prior_defect_value", 0.0)
	defect_bars[index].material.set_shader_parameter("new_defect_value", cell_stat.defect / max_value)


func _display_clean_stat(
	index: int,
	cell_stat: BrainCellStat,
	target_stat: BrainCellStat,
	max_value: float
) -> void:
	
	clean_bars[index].material.set_shader_parameter("old_prisoner_value", 0.0)
	clean_bars[index].material.set_shader_parameter("new_prisoner_value", cell_stat.value / max_value)
	clean_bars[index].material.set_shader_parameter("target_value", target_stat.value / max_value)
