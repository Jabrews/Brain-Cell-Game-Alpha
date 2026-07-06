extends Node

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

func _reset() -> void:
	right_cell_name_label.text = ""

	for defect_bar: TextureProgressBar in right_defect_bars:
		defect_bar.max_value = IVCellCreator.max_stat_value
		defect_bar.value = 0.0

	for clean_bar: Sprite2D in right_clean_bars:
		if clean_bar.material:
			clean_bar.material.set_shader_parameter("prisoner_value", 0.0)
			clean_bar.material.set_shader_parameter("target_value", 0.0)

	for stat_label: Label in right_labels:
		stat_label.modulate.a = 1.0
		stat_label.visible = true

	for hide_stat_sprite: Sprite2D in right_hide_stat_sprites:
		hide_stat_sprite.visible = false

	for off_label: Label in right_off_labels:
		off_label.visible = false
