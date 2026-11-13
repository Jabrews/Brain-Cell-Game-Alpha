extends Node

# componets
@onready var parent_station_attacher : Node = $"../../.."
@onready var failure_chance_view : Control = $"../../../AttacherUI/StatMainView/FailureChanceView"
@onready var refresh_total_failure_chance : Node = $RefreshTotalFailureChance

## hint components
# penality
@onready var penality_chance_increase_labels: Label = $"../../../AttacherUI/StatMainView/FailureChanceView/FailureChanceHint/Penality/PenalityLabel"
# life span
@onready var lifespan_chance_increase_label : Label = $"../../../AttacherUI/StatMainView/FailureChanceView/FailureChanceHint/LifeSpanDanger/FailureChance"
# stats
@onready var stat_chance_increase_labels : Array[Label] = [
	$"../../../AttacherUI/StatMainView/FailureChanceView/FailureChanceHint/StatDanger/Strength/FailureChance",
	$"../../../AttacherUI/StatMainView/FailureChanceView/FailureChanceHint/StatDanger/Intelligence/FailureChance",
	$"../../../AttacherUI/StatMainView/FailureChanceView/FailureChanceHint/StatDanger/Community/FailureChance"
]
@onready var stat_pots : Array[TextureRect] = [
	$"../../../AttacherUI/StatMainView/FailureChanceView/FailureChanceHint/StatDanger/Strength/Pot",
	$"../../../AttacherUI/StatMainView/FailureChanceView/FailureChanceHint/StatDanger/Intelligence/Pot",
	$"../../../AttacherUI/StatMainView/FailureChanceView/FailureChanceHint/StatDanger/Community/Pot"
]
@onready var stat_hidden : Array[Sprite2D] = [
	$"../../../AttacherUI/StatMainView/FailureChanceView/FailureChanceHint/HiddenStats/StrengthHide",
	$"../../../AttacherUI/StatMainView/FailureChanceView/FailureChanceHint/HiddenStats/IntelligenceHide",
	$"../../../AttacherUI/StatMainView/FailureChanceView/FailureChanceHint/HiddenStats/CommunityHide"
]
@onready var stat_disabled : Array[Control] = [
	$"../../../AttacherUI/StatMainView/FailureChanceView/FailureChanceHint/OffDisableLabels/Strength",
	$"../../../AttacherUI/StatMainView/FailureChanceView/FailureChanceHint/OffDisableLabels/Intelligence",
	$"../../../AttacherUI/StatMainView/FailureChanceView/FailureChanceHint/OffDisableLabels/Community"
]

const STAT_TYPES: Array[String] = [
	"strength",
	"intelligence",
	"community"
]


func _ready() -> void:
	for pot : TextureRect in stat_pots : 
		pot.material = pot.material.duplicate()


func _refresh() -> void:
	
	if not parent_station_attacher.failure_rate_enabled	 :
		failure_chance_view.visible = false  
		return
	
	var loaded_cell: BrainCell = parent_station_attacher._get_loaded_cell()

	failure_chance_view.visible = loaded_cell != null
	
	refresh_total_failure_chance._refresh(loaded_cell)

	if not loaded_cell:
		return

	# Non-disabled penalty
	var penalties: Dictionary[String, bool] = GLAttacherComponentBus.main_stat_replacement_failure_penality
	var penalty_increase: int = GAMEFailureChance.attacher_helper._get_total_failure_penality(penalties)

	penality_chance_increase_labels.text = "(+" + str(penalty_increase) + "%)"

	# Lifespan
	var lifespan_increase: int = GAMEFailureChance.attacher_helper._evaluate_lifespan(loaded_cell.life_span)
	lifespan_chance_increase_label.text = "(+" + str(lifespan_increase) + "%)"
	
	refresh_total_failure_chance._refresh(loaded_cell)
#
	# Stats
	display_failure_stats(loaded_cell)


func display_failure_stats(cell: BrainCell) -> void:
	for i: int in STAT_TYPES.size():
		
		var stat_type: String = STAT_TYPES[i]
		var cell_stat: BrainCellStat = cell.get(stat_type)
		
		# see if theres a jar stat 
		# if so. overide for it
		var corrisponding_stat_jar_item : StatJarItem = GLAttacherComponentBus.main_stat_replacement_state[stat_type]
		if corrisponding_stat_jar_item : 
			cell_stat = corrisponding_stat_jar_item.corrisponding_stat
		

		# Failure chance label
		var increase_label: Label = stat_chance_increase_labels[i]

		var increase_amount: float = GAMEFailureChance.attacher_helper._get_stat_failure_chance(cell, stat_type, corrisponding_stat_jar_item)

		increase_label.text = "(+" + str(int(increase_amount)) + "%)"

		if increase_amount != 0.0:
			increase_label.add_theme_color_override("font_color", Color.RED)
		else:
			increase_label.add_theme_color_override("font_color", Color.GRAY)

		# Stat pot
		var pot: TextureRect = stat_pots[i]

		var max_stat_value: float = IVCellCreator.max_stat_value
		var defect_value: float = cell_stat.defect

		var current_defect_value: float = defect_value / max_stat_value

		var next_defect_value: float = GAMECellBreeder.decrease_old_cell._get_increased_defect_stat(defect_value)
		var secondary_defect_value: float = next_defect_value / max_stat_value

		pot.material.set_shader_parameter("current_value", current_defect_value)
		pot.material.set_shader_parameter("secondary_value", secondary_defect_value)

		# Hidden stat
		var hidden_sprite: Sprite2D = stat_hidden[i]
		hidden_sprite.visible = cell_stat.hidden

		# Disabled stat
		var disabled_control: Control = stat_disabled[i]
		disabled_control.visible = not cell_stat.enabled
