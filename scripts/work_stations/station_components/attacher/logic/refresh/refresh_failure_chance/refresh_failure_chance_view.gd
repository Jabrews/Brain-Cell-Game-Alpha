extends Node

# componets
@onready var parent_station_attacher : Node = $"../../.."
@onready var failure_chance_view : Control = $"../../../AttacherUI/Content/StatMainView/BottomSectionHBox/FailureChanceView"
@onready var refresh_total_failure_chance : Node = $RefreshTotalFailureChance

## hint components
# penality
@onready var penality_chance_increase_label : Label = $"../../../AttacherUI/Content/StatMainView/BottomSectionHBox/FailureChanceView/HintParent/FailureChanceHint/Content/Penality/PenalityLabel"
# life span
@onready var lifespan_chance_increase_label : Label = $"../../../AttacherUI/Content/StatMainView/BottomSectionHBox/FailureChanceView/HintParent/FailureChanceHint/Content/TopDangerParent/LifeSpanDanger/FailureChance"
# stats
@onready var stat_chance_increase_labels : Array[Label] = [
	$"../../../AttacherUI/Content/StatMainView/BottomSectionHBox/FailureChanceView/HintParent/FailureChanceHint/Content/TopDangerParent/StatDanger/Strength/Content/FailureChance",
	$"../../../AttacherUI/Content/StatMainView/BottomSectionHBox/FailureChanceView/HintParent/FailureChanceHint/Content/TopDangerParent/StatDanger/Intelligence/Content/FailureChance",
	$"../../../AttacherUI/Content/StatMainView/BottomSectionHBox/FailureChanceView/HintParent/FailureChanceHint/Content/TopDangerParent/StatDanger/Community/Content/FailureChance",
]
@onready var stat_pots : Array[TextureRect] = [
	$"../../../AttacherUI/Content/StatMainView/BottomSectionHBox/FailureChanceView/HintParent/FailureChanceHint/Content/TopDangerParent/StatDanger/Strength/Content/Pot",
	$"../../../AttacherUI/Content/StatMainView/BottomSectionHBox/FailureChanceView/HintParent/FailureChanceHint/Content/TopDangerParent/StatDanger/Intelligence/Content/Pot",
	$"../../../AttacherUI/Content/StatMainView/BottomSectionHBox/FailureChanceView/HintParent/FailureChanceHint/Content/TopDangerParent/StatDanger/Community/Content/Pot",
]
@onready var stat_hidden : Array[TextureRect] = [
	$"../../../AttacherUI/Content/StatMainView/BottomSectionHBox/FailureChanceView/HintParent/FailureChanceHint/Content/TopDangerParent/StatDanger/Strength/HiddenRect",
	$"../../../AttacherUI/Content/StatMainView/BottomSectionHBox/FailureChanceView/HintParent/FailureChanceHint/Content/TopDangerParent/StatDanger/Intelligence/HiddenRect",
	$"../../../AttacherUI/Content/StatMainView/BottomSectionHBox/FailureChanceView/HintParent/FailureChanceHint/Content/TopDangerParent/StatDanger/Community/HiddenRect",
]
@onready var off_parents : Array[Control] = [
	$"../../../AttacherUI/Content/StatMainView/BottomSectionHBox/FailureChanceView/HintParent/FailureChanceHint/Content/TopDangerParent/StatDanger/Strength/OffParent",
	$"../../../AttacherUI/Content/StatMainView/BottomSectionHBox/FailureChanceView/HintParent/FailureChanceHint/Content/TopDangerParent/StatDanger/Intelligence/OffParent",
	$"../../../AttacherUI/Content/StatMainView/BottomSectionHBox/FailureChanceView/HintParent/FailureChanceHint/Content/TopDangerParent/StatDanger/Community/OffParent",
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
		failure_chance_view.modulate.a = 0.0
		return
	else : 
		failure_chance_view.modulate.a = 1.0
	
	var loaded_cell: BrainCell = parent_station_attacher._get_loaded_cell()

	failure_chance_view.visible = loaded_cell != null
	
	refresh_total_failure_chance._refresh(loaded_cell)

	if not loaded_cell:
		return

	# Non-disabled penalty
	var penalties: Dictionary[String, bool] = GLAttacherComponentBus.main_stat_replacement_failure_penality
	var penalty_increase: int = GAMEFailureChance.attacher_helper._get_total_failure_penality(penalties)

	penality_chance_increase_label.text = "(+" + str(penalty_increase) + "%)"

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
		var hidden_sprite: TextureRect = stat_hidden[i]
		hidden_sprite.visible = cell_stat.hidden

		# Disabled stat
		var off_parent : Control = off_parents[i]
		off_parent.visible = not cell_stat.enabled
