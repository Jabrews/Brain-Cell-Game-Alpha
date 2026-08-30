extends Node

@onready var left_cell_name_label: Label = $"../../../../SeatCellLoading/StatDisplay/LeftStatDisplay/StatDisplay/CellName"

@onready var left_defect_bars: Array[TextureProgressBar] = [
	$"../../../../SeatCellLoading/StatDisplay/LeftStatDisplay/StatDisplay/DefectBars/DefectStrengthBar",
 	$"../../../../SeatCellLoading/StatDisplay/LeftStatDisplay/StatDisplay/DefectBars/DefectIntelligenceBar",
 	$"../../../../SeatCellLoading/StatDisplay/LeftStatDisplay/StatDisplay/DefectBars/DefectCommunityBar"
]

@onready var left_clean_bars: Array[Sprite2D] = [
	$"../../../../SeatCellLoading/StatDisplay/LeftStatDisplay/StatDisplay/ProgressBars/StrengthBar",
	$"../../../../SeatCellLoading/StatDisplay/LeftStatDisplay/StatDisplay/ProgressBars/IntelligenceBar",
	$"../../../../SeatCellLoading/StatDisplay/LeftStatDisplay/StatDisplay/ProgressBars/CommunityBar"
]

@onready var left_labels: Array[Label] = [
	$"../../../../SeatCellLoading/StatDisplay/LeftStatDisplay/StatDisplay/ProgressBars/StengthLabel",
	$"../../../../SeatCellLoading/StatDisplay/LeftStatDisplay/StatDisplay/ProgressBars/IntelligenceLabel",
	$"../../../../SeatCellLoading/StatDisplay/LeftStatDisplay/StatDisplay/ProgressBars/CommunityLabel"
]

@onready var left_hide_stat_sprites: Array[Sprite2D] = [
	$"../../../../SeatCellLoading/StatDisplay/LeftStatDisplay/StatDisplay/HiddenStats/StrengthHide",
	$"../../../../SeatCellLoading/StatDisplay/LeftStatDisplay/StatDisplay/HiddenStats/IntelligenceHide",
	$"../../../../SeatCellLoading/StatDisplay/LeftStatDisplay/StatDisplay/HiddenStats/CommunityHide"
]

@onready var left_off_labels: Array[Label] = [
	$"../../../../SeatCellLoading/StatDisplay/LeftStatDisplay/StatDisplay/OffDisableLabels/StrengthOffLabel",
	$"../../../../SeatCellLoading/StatDisplay/LeftStatDisplay/StatDisplay/OffDisableLabels/IntelligenceOffLabel",
	$"../../../../SeatCellLoading/StatDisplay/LeftStatDisplay/StatDisplay/OffDisableLabels/CommunityOffLabel"
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
