
extends Node

const STAT_TYPES: Array[String] = [
	"strength",
	"intelligence",
	"community"
]

@export var penality_increase: float = 15.0

@export var defect_percant_increase: Dictionary[int, float] = {
	1: 50.0,
	2: 51.0,
}

@export var life_span_increase: Dictionary[int, float] = {
	5: 0.0,
	4: 0.0,
	3: 0.0,
	2: 5.0,
	1: 15.0,
	0: 20.0,
}


func _get_total_failure_chance(
	cell: BrainCell,
	stat_replacement_failure_penality: Dictionary[String, bool],
	stat_replacement_state: Dictionary[String, StatJarItem]
) -> int:

	var total_failure_chance: float = 0.0

	# Penalties
	total_failure_chance += _get_total_failure_penality(
		stat_replacement_failure_penality
	)

	# Lifespan
	total_failure_chance += _evaluate_lifespan(cell.life_span)

	# Stat failure chances
	for stat_type: String in STAT_TYPES:
		var stat_jar_item: StatJarItem = stat_replacement_state.get(stat_type)

		total_failure_chance += _get_stat_failure_chance(
			cell,
			stat_type,
			stat_jar_item
		)

	return int(total_failure_chance)


func _get_total_failure_penality(
	stat_replacement_failure_penality: Dictionary[String, bool]
) -> float:

	var penalties_active: int = 0

	for value: bool in stat_replacement_failure_penality.values():
		if value:
			penalties_active += 1

	return penalties_active * penality_increase


func _evaluate_lifespan(life_span: int) -> float:
	return life_span_increase.get(life_span, 0.0)


func _get_stat_failure_chance(
	loaded_cell: BrainCell,
	selected_stat: String,
	stat_jar_item: StatJarItem
) -> float:

	var cell_stat: BrainCellStat = loaded_cell.get_stat(selected_stat)

	# Override original stat when a jar item is present
	if stat_jar_item:
		cell_stat = stat_jar_item.corrisponding_stat

	if not cell_stat:
		return 0.0

	var max_stat: float = IVCellCreator.max_stat_value
	if max_stat <= 0.0:
		return 0.0

	var defect_percent: float = (cell_stat.defect / max_stat) * 100.0

	# 75%+ defect
	if defect_percent >= 75.0:
		return defect_percant_increase.get(2, 0.0)

	# 20% - 75% defect
	if defect_percent >= 20.0:
		return defect_percant_increase.get(1, 0.0)

	return 0.0
