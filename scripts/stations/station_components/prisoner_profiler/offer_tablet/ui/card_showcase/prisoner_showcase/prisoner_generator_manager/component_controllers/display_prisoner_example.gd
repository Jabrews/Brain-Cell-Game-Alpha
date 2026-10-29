extends Node

@onready var clean_bars: Array[Sprite2D] = [
	$"../../../PrisGenerator/PrisonerExample/Strength/Bar",
	$"../../../PrisGenerator/PrisonerExample/Intelligence/Bar",
	$"../../../PrisGenerator/PrisonerExample/Community/Bar"
]

@onready var defect_bars: Array[Sprite2D] = [
	$"../../../PrisGenerator/PrisonerExample/Strength/DefectBar",
	$"../../../PrisGenerator/PrisonerExample/Intelligence/DefectBar",
	$"../../../PrisGenerator/PrisonerExample/Community/DefectBar"
]

@onready var disabled_parents: Array[Control] = [
	$"../../../PrisGenerator/PrisonerExample/Strength/Disabled",
	$"../../../PrisGenerator/PrisonerExample/Intelligence/Disabled",
	$"../../../PrisGenerator/PrisonerExample/Community/Disabled",
]

# ADMIN STUFF 
# IGNORE
@onready var debug_stat_data_labels : Array[Label] = [
	$"../../../PrisGenerator/PrisonerExample/DebugStatDataLabels/StrengthLabel", 
	$"../../../PrisGenerator/PrisonerExample/DebugStatDataLabels/IntelligenceLabel", 
	$"../../../PrisGenerator/PrisonerExample/DebugStatDataLabels/CommunityLabel"
]


func _ready() -> void:
	for bar: Sprite2D in clean_bars:
		bar.material = bar.material.duplicate()

	for bar: Sprite2D in defect_bars:
		bar.material = bar.material.duplicate()


func _display(prisoner_cell: BrainCell, prisoner_card: PrisonerOfferCard) -> void:
	var cell_stats: Array[BrainCellStat] = [
		prisoner_cell.strength,
		prisoner_cell.intelligence,
		prisoner_cell.community
	]

	var card_stats: Array[PrisonerCardStat] = [
		prisoner_card.strength,
		prisoner_card.intelligence,
		prisoner_card.community
	]

	var max_stat_value: float = IVCellCreator.max_stat_value
	if max_stat_value <= 0.0:
		push_error("IVCellCreator.max_stat_value must be greater than 0.")
		return


	for index in range(cell_stats.size()):
		var cell_stat := cell_stats[index]
		var card_stat := card_stats[index]
		var clean_bar := clean_bars[index]
		var defect_bar := defect_bars[index]
		var disabled_parent := disabled_parents[index]
		var debug_stat_data_label := debug_stat_data_labels[index]
		

		

		var stat_enabled: bool = card_stat.enabled
		disabled_parent.visible = not stat_enabled
		clean_bar.visible = stat_enabled
		defect_bar.visible = stat_enabled
		
		if GLGameManagerBus.debug_prisoner_showcase_show_stat_data and stat_enabled:
			debug_stat_data_label.visible = true

			if cell_stat.admin_data.has("defect_gen_case"):
				debug_stat_data_label.text = str(
					cell_stat.admin_data["defect_gen_case"]
				)
			else:
				debug_stat_data_label.text = "No defect gen case"
		else:
			debug_stat_data_label.visible = false
					
		

		if not stat_enabled:
			continue

		var clean_material := clean_bar.material as ShaderMaterial
		var defect_material := defect_bar.material as ShaderMaterial

		var prisoner_value := clampf(
			cell_stat.value / max_stat_value,
			0.0,
			1.0
		)
		var min_value := clampf(
			card_stat.min_value / max_stat_value,
			0.0,
			1.0
		)
		var max_value := clampf(
			card_stat.max_value / max_stat_value,
			0.0,
			1.0
		)
		var defect_value := clampf(
			cell_stat.defect / max_stat_value,
			0.0,
			1.0
		)

		clean_material.set_shader_parameter("prisoner_value", prisoner_value)
		clean_material.set_shader_parameter("base_min_value", min_value)
		clean_material.set_shader_parameter("base_max_value", max_value)

		defect_material.set_shader_parameter("defect_value", defect_value)
