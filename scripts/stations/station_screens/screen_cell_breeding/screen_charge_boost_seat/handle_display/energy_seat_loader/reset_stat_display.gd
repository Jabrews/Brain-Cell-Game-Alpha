extends Node

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

func _reset() :
	cell_name_label.text = ""

	for defect_bar: Sprite2D in defect_bars:
		defect_bar.material.set_shader_parameter("prior_defect_value", 0.0)
		defect_bar.material.set_shader_parameter("new_defect_value", 0.0)

	for clean_bar: Sprite2D in clean_bars:
		if clean_bar.material:
			clean_bar.material.set_shader_parameter("old_prisoner_value", 0.0)
			clean_bar.material.set_shader_parameter("new_prisoner_value", 0.0)
			clean_bar.material.set_shader_parameter("target_value", 0.0)

	for stat_label: Label in clean_stat_labels:
		stat_label.modulate.a = 1.0
		stat_label.visible = true

	for hide_stat_sprite: Sprite2D in hide_stat_sprites:
		hide_stat_sprite.visible = false

	for off_label: Label in off_labels:
		off_label.visible = false
