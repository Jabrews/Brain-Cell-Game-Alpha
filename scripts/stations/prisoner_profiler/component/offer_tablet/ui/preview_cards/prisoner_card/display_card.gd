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
# alteration display

func _ready() -> void:
	for stat_bar : Sprite2D in stat_bars : 
		stat_bar.material = stat_bar.material.duplicate()


func _display(prisoner_card : PrisonerOfferCard, ideal_stats : Array[IdealStat]) :
	
	display_stats(prisoner_card, ideal_stats)
	
	defect_rate_label.text = str(prisoner_card.defect_rate) + '%'

	
func display_stats(prisoner_card : PrisonerOfferCard, ideal_stats : Array[IdealStat]) :
	# get stats array
	var stats : Array[PrisonerCardStat] = []
	stats.append(prisoner_card.strength)
	stats.append(prisoner_card.intelligence)
	stats.append(prisoner_card.community)
	
	var curr_index = 0
	
	while curr_index != len(stats) : 
		
		var stat : PrisonerCardStat = stats[curr_index]
		var bar : Sprite2D  = stat_bars[curr_index]
		var disabled_parent : Control = disabled_parents[curr_index]
		
		# enabled / disabled blocker
		if not stat.enabled : 
			disabled_parent.visible = true
			return
		else  :
			disabled_parent.visible = false 
		
		# bar value
		
		var ideal_stat : IdealStat = ideal_stats[curr_index]
		
		var max_stat_value: float = IVCellCreator.max_stat_value

		if max_stat_value <= 0.0:
			push_error("max_stat_value must be greater than 0.")
			return

		var yellow_min_value: float = clampf(
			stat.min_value / max_stat_value,
			0.0,
			1.0
		)

		var yellow_max_value: float = clampf(
			stat.max_value / max_stat_value,
			0.0,
			1.0
		)
		bar.material.set_shader_parameter("yellow_min_value", yellow_min_value)
		bar.material.set_shader_parameter("yellow_max_value", yellow_max_value)
		
		var base_value : float = clampf(
			ideal_stat.value / max_stat_value,
			0.0,
			1.0
		)
		
		bar.material.set_shader_parameter("base_value", base_value)
		
		
		curr_index += 1	
