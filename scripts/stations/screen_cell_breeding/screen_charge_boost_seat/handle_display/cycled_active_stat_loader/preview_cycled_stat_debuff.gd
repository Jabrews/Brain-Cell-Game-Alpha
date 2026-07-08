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

@onready var clean_bars: Array[Sprite2D] = [
	$"../../../StatDisplay/ProgressBars/StrengthBar",
	$"../../../StatDisplay/ProgressBars/IntelligenceBar",
	$"../../../StatDisplay/ProgressBars/CommunityBar"
]

var active_brain_cell: BrainCell


func _handle_preview_debuff(cycled_stat: String, energy_boost_cell : BrainCell) -> void:
	
	
	# get current stat object and target stat
	var before_debuff_stat : BrainCellStat
	var target_stat : BrainCellStat
	var target_cell : BrainCell = GLCellManagerBus.target_cell_refrence
	var selected_defect_bar : Sprite2D
	var selected_clean_bar : Sprite2D
	
	match cycled_stat : 
		'strength' :
			before_debuff_stat = energy_boost_cell.strength
			target_stat = target_cell.strength
			selected_defect_bar = defect_bars[0]
			selected_clean_bar = clean_bars[0]
		'intelligence' :
			before_debuff_stat = energy_boost_cell.intelligence
			target_stat = target_cell.intelligence
			selected_defect_bar = defect_bars[1]
			selected_clean_bar = clean_bars[1]
		'community' :
			before_debuff_stat = energy_boost_cell.community
			target_stat = target_cell.community
			selected_defect_bar = defect_bars[2]
			selected_clean_bar = clean_bars[2]
	
	# get after debuff stat
	var after_debuff_stat: BrainCellStat = GAMECellBreeder.reduced_cell_charge_stat_helper._get_reduced(cycled_stat, energy_boost_cell)
	
	var max_value : float = IVCellCreator.max_stat_value
	
	# set clean stat value
	selected_clean_bar.material.set_shader_parameter("old_prisoner_value", before_debuff_stat.value / max_value)
	selected_clean_bar.material.set_shader_parameter("new_prisoner_value", after_debuff_stat.value / max_value)
	selected_clean_bar.material.set_shader_parameter("target_value", target_stat.value / max_value)
	
	# set defect stat value
	selected_defect_bar.material.set_shader_parameter("prior_defect_value", before_debuff_stat.defect / max_value)
	selected_defect_bar.material.set_shader_parameter("new_defect_value", after_debuff_stat.defect / max_value)
	
	
	
	
	
	
	
	
