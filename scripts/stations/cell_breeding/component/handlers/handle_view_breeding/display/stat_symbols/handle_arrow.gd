
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


func _handle(stat_1 : BrainCellStat, stat_2 : BrainCellStat, stat_index : int) -> void:

	up_arrows[stat_index].visible = false
	down_arrows[stat_index].visible = false

	# disabled stats don't show arrows
	if not stat_1.enabled or not stat_2.enabled:
		return

	var stat_array = GAMECellBreeder.clean_stat_helper.get_highest_lowest_stat(
		stat_1.value,
		stat_2.value
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
		stat_low,
	):
		up_arrows[stat_index].visible = true
	else:
		down_arrows[stat_index].visible = true
