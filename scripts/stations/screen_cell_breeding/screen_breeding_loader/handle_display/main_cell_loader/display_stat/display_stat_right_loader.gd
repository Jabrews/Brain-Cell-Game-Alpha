extends Node

const STAT_TYPES: Array[String] = [
	"strength",
	"intelligence",
	"community",
]

@onready var right_cell_name_label: Label = $"../../../SeatCellLoading/RightLoader/LoadedCellDisplay/CellName"

@onready var right_defect_bars: Array[TextureProgressBar] = [
	$"../../../SeatCellLoading/RightLoader/LoadedCellDisplay/DefectBars/DefectStrengthBar",
	$"../../../SeatCellLoading/RightLoader/LoadedCellDisplay/DefectBars/DefectIntelligenceBar",
	$"../../../SeatCellLoading/RightLoader/LoadedCellDisplay/DefectBars/DefectCommunityBar"
]

@onready var right_clean_bars: Array[Sprite2D] = [
	$"../../../SeatCellLoading/RightLoader/LoadedCellDisplay/ProgressBars/StrengthBar",
	$"../../../SeatCellLoading/RightLoader/LoadedCellDisplay/ProgressBars/IntelligenceBar",
	$"../../../SeatCellLoading/RightLoader/LoadedCellDisplay/ProgressBars/CommunityBar"
]

@onready var right_labels: Array[Label] = [
	$"../../../SeatCellLoading/RightLoader/LoadedCellDisplay/ProgressBars/StengthLabel",
	$"../../../SeatCellLoading/RightLoader/LoadedCellDisplay/ProgressBars/IntelligenceLabel",
	$"../../../SeatCellLoading/RightLoader/LoadedCellDisplay/ProgressBars/CommunityLabel"
]

@onready var right_hide_stat_sprites: Array[Sprite2D] = [
	$"../../../SeatCellLoading/RightLoader/LoadedCellDisplay/HideStats/StrengthHide",
	$"../../../SeatCellLoading/RightLoader/LoadedCellDisplay/HideStats/IntelligenceHide",
	$"../../../SeatCellLoading/RightLoader/LoadedCellDisplay/HideStats/CommunityHide"
]

@onready var right_off_labels: Array[Label] = [
	$"../../../SeatCellLoading/RightLoader/LoadedCellDisplay/OffDisableLabels/StrengthOffLabel",
	$"../../../SeatCellLoading/RightLoader/LoadedCellDisplay/OffDisableLabels/IntelligenceOffLabel",
	$"../../../SeatCellLoading/RightLoader/LoadedCellDisplay/OffDisableLabels/CommunityOffLabel"
]


func _ready() -> void:
	for clean_bar: Sprite2D in right_clean_bars:
		clean_bar.material = clean_bar.material.duplicate()


func _display_cell(brain_cell: BrainCell) -> void:
	if brain_cell == null:
		return

	display(brain_cell)


func display(brain_cell: BrainCell) -> void:
	var target_cell: BrainCell = GLCellManagerBus.target_cell_refrence
	var max_value: float = float(IVCellCreator.max_stat_value)

	right_cell_name_label.text = str(brain_cell.name)

	for i: int in range(STAT_TYPES.size()):
		var stat_type: String = STAT_TYPES[i]

		var cell_stat: BrainCellStat = brain_cell.get(stat_type)
		var target_stat: BrainCellStat = target_cell.get(stat_type)

		if not cell_stat.enabled:
			_display_disabled_stat(i)
			continue

		_display_hidden_stat(i, cell_stat)
		_display_defect_stat(i, cell_stat)
		_display_clean_stat(i, cell_stat, target_stat, max_value)


func _display_disabled_stat(index: int) -> void:
	right_off_labels[index].visible = true
	right_labels[index].modulate.a = 0.4


func _display_hidden_stat(
	index: int,
	cell_stat: BrainCellStat,
) -> void:
	right_hide_stat_sprites[index].visible = cell_stat.hidden


func _display_defect_stat(
	index: int,
	cell_stat: BrainCellStat,
) -> void:
	right_defect_bars[index].value = cell_stat.defect


func _display_clean_stat(
	index: int,
	cell_stat: BrainCellStat,
	target_stat: BrainCellStat,
	max_value: float
) -> void:
	right_clean_bars[index].material.set_shader_parameter(
		"prisoner_value",
		cell_stat.value / max_value
	)

	right_clean_bars[index].material.set_shader_parameter(
		"target_value",
		target_stat.value / max_value
	)
	
	right_clean_bars[index].material.set_shader_parameter(
		"charge_value",
		cell_stat.value / max_value
	)
