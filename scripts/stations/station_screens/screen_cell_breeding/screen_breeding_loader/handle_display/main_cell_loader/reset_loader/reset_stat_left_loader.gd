extends Node

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

func _reset() -> void:
	left_cell_name_label.text = ""

	for defect_bar: TextureProgressBar in left_defect_bars:
		defect_bar.max_value = IVCellCreator.max_stat_value
		defect_bar.value = 0.0

	for clean_bar: Sprite2D in left_clean_bars:
		if clean_bar.material:
			clean_bar.material.set_shader_parameter("prisoner_value", 0.0)
			clean_bar.material.set_shader_parameter("target_value", 0.0)
			clean_bar.material.set_shader_parameter("charge_value", 0.0)

	for stat_label: Label in left_labels:
		stat_label.modulate.a = 1.0
		stat_label.visible = true

	for hide_stat_sprite: Sprite2D in left_hide_stat_sprites:
		hide_stat_sprite.visible = false

	for off_label: Label in left_off_labels:
		off_label.visible = false
