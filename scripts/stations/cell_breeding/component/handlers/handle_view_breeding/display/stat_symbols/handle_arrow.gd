extends Node

@onready var up_arrows : Array[Sprite2D] = [
	$"../../../../BreedingUI/CellLoader/BreedingView/StatDisplay/ArrowUp/UpStrength",
	$"../../../../BreedingUI/CellLoader/BreedingView/StatDisplay/ArrowUp/UpIntelligence",
	$"../../../../BreedingUI/CellLoader/BreedingView/StatDisplay/ArrowUp/UpCommunity"
]

@onready var down_arrows : Array[Sprite2D] = [
	$"../../../../BreedingUI/CellLoader/BreedingView/StatDisplay/ArrowDown/DownStrength",
	$"../../../../BreedingUI/CellLoader/BreedingView/StatDisplay/ArrowDown/DownIntelligence",
	$"../../../../BreedingUI/CellLoader/BreedingView/StatDisplay/ArrowDown/DownCommunity"
]

var stats : Array[String] = [
	"strength",
	"intelligence",
	"community"
]


func _handle(
	stat_1 : BrainCellStat,
	stat_2 : BrainCellStat,
	stat_index : int
) -> void:

	up_arrows[stat_index].visible = false
	down_arrows[stat_index].visible = false

	# disabled stats don't show arrows
	if not stat_1.enabled or not stat_2.enabled:
		return
	
	var stat_type : String = stats[stat_index]
	
	var stat_1_value : float = stat_1.value
	var stat_2_value : float = stat_2.value
	
	# apply left boost preview
	stat_1_value = _apply_boost(
		stat_1_value,
		stat_type,
		GLBreedingComponetsBus.left_boost_stat,
		GLBreedingComponetsBus.left_boost_direction
	)
	
	# apply right boost preview
	stat_2_value = _apply_boost(
		stat_2_value,
		stat_type,
		GLBreedingComponetsBus.right_boost_stat,
		GLBreedingComponetsBus.right_boost_direction
	)
	
	# use boosted values for breeding prediction
	var stat_array = GAMECellBreeder.clean_stat_helper.get_highest_lowest_stat(
		stat_1_value,
		stat_2_value
	)

	var stat_high : float = stat_array[0]
	var stat_low : float = stat_array[1]

	var increase_case_min : float = (
		stat_high * IVCellBreeding.clean_stat_increase_case_min
	)

	# same logic as breeding system
	if increase_case_min <= stat_low:
		up_arrows[stat_index].visible = true
		return

	if GAMECellBreeder.clean_stat_helper.handle_detect_early_stats(
		stat_high,
		stat_low
	):
		up_arrows[stat_index].visible = true
	else:
		down_arrows[stat_index].visible = true


func _apply_boost(
	stat_value : float,
	stat_type : String,
	boost_stat : String,
	boost_direction : String
) -> float:
	
	# boost doesn't apply to this stat
	if boost_stat != stat_type:
		return stat_value
	
	# direction hasn't been selected yet
	if boost_direction == "none":
		return stat_value
	
	var direction_multiplier : float
	
	match boost_direction:
		"up":
			direction_multiplier = 1.0
		
		"down":
			direction_multiplier = -1.0
		
		_:
			push_error("Invalid boost direction: ", boost_direction)
			return stat_value
	
	var boost_difference : float = (
		IVCellCreator.max_stat_value * 0.15 * direction_multiplier
	)
	
	return clamp(
		stat_value + boost_difference,
		0.0,
		IVCellCreator.max_stat_value
	)
