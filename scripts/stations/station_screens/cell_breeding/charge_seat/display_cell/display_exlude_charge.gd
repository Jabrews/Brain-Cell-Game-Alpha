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

var active_brain_cell : BrainCell

func display(brain_cell: BrainCell) -> void:
	active_brain_cell = brain_cell
	
	cell_name_label.text = active_brain_cell.name
	
	var enabled_stats: Array[String] = [
		"strength",
		"intelligence",
		"community"
	]
	
	enabled_stats = find_disabled_stats(enabled_stats)
	
	for enabled_stat: String in enabled_stats:
		display_hidden(enabled_stat)
		display_defect(enabled_stat)
		display_clean(enabled_stat)


func find_disabled_stats(enabled_stats: Array[String]) -> Array[String]:
	if not active_brain_cell.strength.enabled:
		enabled_stats.erase("strength")
		toggle_disable_label("strength")
	
	if not active_brain_cell.intelligence.enabled:
		enabled_stats.erase("intelligence")
		toggle_disable_label("intelligence")
	
	if not active_brain_cell.community.enabled:
		enabled_stats.erase("community")
		toggle_disable_label("community")
	
	return enabled_stats


func toggle_disable_label(stat_type: String) -> void:
	match stat_type:
		"strength":
			off_display_labels[0].visible = true
			progress_bars_labels[0].modulate.a = 0.4
			progress_bars[0].visible = false
			defect_bars[0].visible = false
		
		"intelligence":
			off_display_labels[1].visible = true
			progress_bars_labels[1].modulate.a = 0.4
			progress_bars[1].visible = false
			defect_bars[1].visible = false
		
		"community":
			off_display_labels[2].visible = true
			progress_bars_labels[2].modulate.a = 0.4
			progress_bars[2].visible = false
			defect_bars[2].visible = false
		
		_:
			push_error("Cannot find disabled label for stat type: " + stat_type)


func display_hidden(stat_type: String) -> void:
	match stat_type:
		"strength":
			hide_stat_sprites[0].visible = active_brain_cell.strength.hidden
		
		"intelligence":
			hide_stat_sprites[1].visible = active_brain_cell.intelligence.hidden
		
		"community":
			hide_stat_sprites[2].visible = active_brain_cell.community.hidden


func display_defect(stat_type: String) -> void:
	var selected_bar: Sprite2D
	var defect_value: float = 0.0
	
	match stat_type:
		"strength":
			selected_bar = defect_bars[0]
			defect_value = active_brain_cell.strength.defect
		
		"intelligence":
			selected_bar = defect_bars[1]
			defect_value = active_brain_cell.intelligence.defect
		
		"community":
			selected_bar = defect_bars[2]
			defect_value = active_brain_cell.community.defect
		
		_:
			push_error("Invalid defect stat type: " + stat_type)
			return
	
	var max_value: float = float(IVCellCreator.max_stat_value)
	var normalized_defect: float = clamp(defect_value / max_value, 0.0, 1.0)
	
	# Not using prior value right now.
	selected_bar.material.set_shader_parameter("prior_defect_value", 0.0)
	selected_bar.material.set_shader_parameter("new_defect_value", normalized_defect)


func display_clean(stat_type: String) -> void:
	var target_cell: BrainCell = GLCellManagerBus.target_cell_refrence
	
	if not target_cell:
		return
	
	var selected_bar: Sprite2D
	var cell_value: float = 0.0
	var target_value: float = 0.0
	
	match stat_type:
		"strength":
			selected_bar = progress_bars[0]
			cell_value = active_brain_cell.strength.value
			target_value = target_cell.strength.value
		
		"intelligence":
			selected_bar = progress_bars[1]
			cell_value = active_brain_cell.intelligence.value
			target_value = target_cell.intelligence.value
		
		"community":
			selected_bar = progress_bars[2]
			cell_value = active_brain_cell.community.value
			target_value = target_cell.community.value
		
		_:
			push_error("Invalid clean stat type: " + stat_type)
			return
	
	var max_value: float = float(IVCellCreator.max_stat_value)
	
	var normalized_cell_value: float = clamp(cell_value / max_value, 0.0, 1.0)
	var normalized_target_value: float = clamp(target_value / max_value, 0.0, 1.0)
	
	# Not using old value right now.
	selected_bar.material.set_shader_parameter("old_prisoner_value", 0.0)
	selected_bar.material.set_shader_parameter("new_prisoner_value", normalized_cell_value)
	selected_bar.material.set_shader_parameter("target_value", normalized_target_value)


func reset_cell_display() -> void:
	active_brain_cell = null
	
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
