extends Node

# stats
@onready var stat_bars : Array[Sprite2D] = [
	$"../StatDisplay/Strength/Bar", $"../StatDisplay/Intelligence/Bar", $"../StatDisplay/Community/Bar"
]
@onready var disabled_parents : Array[Control] = [
	$"../StatDisplay/Strength/Disabled", $"../StatDisplay/Intelligence/Disabled", $"../StatDisplay/Community/Disabled"
]
# labels / properties
@onready var defect_rate_label : Label = $"../DefectRate/DefectRatePercantLabel"


func _ready() -> void:
	for stat_bar : Sprite2D in stat_bars : 
		stat_bar.material = stat_bar.material.duplicate()


func _display(prisoner_card : PrisonerOfferCard, ideal_stats : Array[IdealStat]) :
	
	display_stats(prisoner_card, ideal_stats)
	
	defect_rate_label.text = str(prisoner_card.total_defect_rate) + '%'

	
func display_stats(
	prisoner_card: PrisonerOfferCard,
	ideal_stats: Array[IdealStat]
) -> void:
	var stats: Array[PrisonerCardStat] = [
		prisoner_card.strength,
		prisoner_card.intelligence,
		prisoner_card.community
	]

	var max_stat_value: float = IVCellCreator.max_stat_value
	if max_stat_value <= 0.0:
		push_error("max_stat_value must be greater than 0.")
		return

	for index in range(stats.size()):
		var stat: PrisonerCardStat = stats[index]
		var bar: Sprite2D = stat_bars[index]
		var disabled_parent: Control = disabled_parents[index]

		if not stat.enabled:
			disabled_parent.visible = true
			continue

		disabled_parent.visible = false

		var ideal_stat: IdealStat = ideal_stats[index]
		var bar_material := bar.material as ShaderMaterial

		bar_material.set_shader_parameter(
			"yellow_min_value",
			clampf(stat.min_value / max_stat_value, 0.0, 1.0)
		)
		bar_material.set_shader_parameter(
			"yellow_max_value",
			clampf(stat.max_value / max_stat_value, 0.0, 1.0)
		)
		bar_material.set_shader_parameter(
			"base_value",
			clampf(ideal_stat.value / max_stat_value, 0.0, 1.0)
		)
