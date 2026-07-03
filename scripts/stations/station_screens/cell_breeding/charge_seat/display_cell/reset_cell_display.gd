extends Node

@onready var cell_name_label: Label = $"../../StatDisplay/CellName"

@onready var defect_bars: Array[Sprite2D] = [
	$"../../StatDisplay/DefectBars/DefectStrengthBar",
	$"../../StatDisplay/DefectBars/DefectIntelligenceBar",
	$"../../StatDisplay/DefectBars/DefectCommunityBar"
]

@onready var progress_bars: Array[Sprite2D] = [
	$"../../StatDisplay/ProgressBars/StrengthBar",
	$"../../StatDisplay/ProgressBars/IntelligenceBar",
	$"../../StatDisplay/ProgressBars/CommunityBar"
]

@onready var progress_bars_labels: Array[Label] = [
	$"../../StatDisplay/ProgressBars/StengthLabel",
	$"../../StatDisplay/ProgressBars/IntelligenceLabel",
	$"../../StatDisplay/ProgressBars/CommunityLabel"
]

@onready var hide_stat_sprites: Array[Sprite2D] = [
	$"../../StatDisplay/HideStats/StrengthHide",
	$"../../StatDisplay/HideStats/IntelligenceHide",
	$"../../StatDisplay/HideStats/CommunityHide"
]

@onready var off_display_labels: Array[Label] = [
	$"../../StatDisplay/OffDisableLabels/StrengthOffLabel",
	$"../../StatDisplay/OffDisableLabels/IntelligenceOffLabel",
	$"../../StatDisplay/OffDisableLabels/CommunityOffLabel"
]

func reset() :
		
	cell_name_label.text = ""
	
	for i in range(progress_bars.size()):
		progress_bars[i].visible = true
		defect_bars[i].visible = true
		
		progress_bars_labels[i].visible = true
		progress_bars_labels[i].modulate.a = 1.0
		
		hide_stat_sprites[i].visible = false
		off_display_labels[i].visible = false
		
		progress_bars[i].material.set_shader_parameter("old_prisoner_value", 0.0)
		progress_bars[i].material.set_shader_parameter("new_prisoner_value", 0.0)
		progress_bars[i].material.set_shader_parameter("target_value", 0.0)
		
		defect_bars[i].material.set_shader_parameter("prior_defect_value", 0.0)
		defect_bars[i].material.set_shader_parameter("new_defect_value", 0.0)

	
