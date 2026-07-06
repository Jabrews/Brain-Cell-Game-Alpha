extends Node

const STAT_TYPES: Array[String] = [
	"strength",
	"intelligence",
	"community",
]

@onready var left_cell_name_label: Label = $"../../../SeatCellLoading/LeftLoader/LoadedCellDisplay/CellName"

@onready var left_defect_bars: Array[TextureProgressBar] = [
	$"../../../SeatCellLoading/LeftLoader/LoadedCellDisplay/DefectBars/DefectStrengthBar",
	$"../../../SeatCellLoading/LeftLoader/LoadedCellDisplay/DefectBars/DefectIntelligenceBar",
	$"../../../SeatCellLoading/LeftLoader/LoadedCellDisplay/DefectBars/DefectCommunityBar"
]

@onready var left_clean_bars: Array[Sprite2D] = [
	$"../../../SeatCellLoading/LeftLoader/LoadedCellDisplay/ProgressBars/StrengthBar",
	$"../../../SeatCellLoading/LeftLoader/LoadedCellDisplay/ProgressBars/IntelligenceBar",
	$"../../../SeatCellLoading/LeftLoader/LoadedCellDisplay/ProgressBars/CommunityBar"
]

@onready var left_labels: Array[Label] = [
	$"../../../SeatCellLoading/LeftLoader/LoadedCellDisplay/ProgressBars/StengthLabel",
	$"../../../SeatCellLoading/LeftLoader/LoadedCellDisplay/ProgressBars/IntelligenceLabel",
	$"../../../SeatCellLoading/LeftLoader/LoadedCellDisplay/ProgressBars/CommunityLabel"
]

@onready var left_hide_stat_sprites: Array[Sprite2D] = [
	$"../../../SeatCellLoading/LeftLoader/LoadedCellDisplay/HideStats/StrengthHide",
	$"../../../SeatCellLoading/LeftLoader/LoadedCellDisplay/HideStats/IntelligenceHide",
	$"../../../SeatCellLoading/LeftLoader/LoadedCellDisplay/HideStats/CommunityHide"
]

@onready var left_off_labels: Array[Label] = [
	$"../../../SeatCellLoading/LeftLoader/LoadedCellDisplay/OffDisableLabels/StrengthOffLabel",
	$"../../../SeatCellLoading/LeftLoader/LoadedCellDisplay/OffDisableLabels/IntelligenceOffLabel",
	$"../../../SeatCellLoading/LeftLoader/LoadedCellDisplay/OffDisableLabels/CommunityOffLabel"
]


func _ready() -> void:
	for clean_bar: Sprite2D in left_clean_bars:
		clean_bar.material = clean_bar.material.duplicate()


func _display_cell(brain_cell: BrainCell) -> void:
	if brain_cell == null:
		return

	display(brain_cell)


func display(
	brain_cell: BrainCell,
) -> void:
	var target_cell: BrainCell = GLCellManagerBus.target_cell_refrence
	var max_value: float = float(IVCellCreator.max_stat_value)

	left_cell_name_label.text = str(brain_cell.name)

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
	left_off_labels[index].visible = true
	left_labels[index].modulate.a = 0.4


func _display_hidden_stat(
	index: int,
	cell_stat: BrainCellStat,
) -> void:
	left_hide_stat_sprites[index].visible = cell_stat.hidden


func _display_defect_stat(
	index: int,
	cell_stat: BrainCellStat,
) -> void:
	left_defect_bars[index].value = cell_stat.defect


func _display_clean_stat(
	index: int,
	cell_stat: BrainCellStat,
	target_stat: BrainCellStat,
	max_value: float
) -> void:
	left_clean_bars[index].material.set_shader_parameter(
		"prisoner_value",
		cell_stat.value / max_value
	)

	left_clean_bars[index].material.set_shader_parameter(
		"target_value",
		target_stat.value / max_value
	)
