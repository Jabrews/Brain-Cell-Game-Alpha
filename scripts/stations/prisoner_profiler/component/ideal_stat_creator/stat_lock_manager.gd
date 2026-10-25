extends Node

@onready var parent_ideal_stat_creator: Node = $".."

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') :
		print('strength lock index : ', IVPrisonerProfiler.strength_stat_lock_percant_index)
		print('int lock index : ', IVPrisonerProfiler.intelligence_stat_lock_percant_index)
		print('com lock index : ', IVPrisonerProfiler.community_stat_lock_percant_index)
		#_initate_new_stat_locks()
		#var str_ideal_stat : IdealStat = parent_ideal_stat_creator.strength_ideal_stat
		#print('strength lock max value : ', str_ideal_stat.lock_max_value)
		#print('strength lock index : ', IVPrisonerProfiler.strength_stat_lock_percant_index)



func _initate_new_stat_locks() -> void:
	var max_value: float = IVCellCreator.max_stat_value
	var percentages: Array[float] = IVPrisonerProfiler.stat_lock_percantages

	if max_value <= 0.0:
		push_error("max_stat_value must be greater than 0.")
		return

	if percentages.is_empty():
		push_error("stat_lock_percantages is empty.")
		return

	# Percentages range from zero to the start of the unreachable region.
	var available_max_value: float = clampf(
		IVPrisonerProfiler.uncreachable_min_value,
		0.0,
		max_value
	)

	# Find the highest enabled stat value across collected cells.
	var highest_clean_values: Dictionary[String, float] = {
		"strength": 0.0,
		"intelligence": 0.0,
		"community": 0.0,
	}

	var collected_cells: Array[BrainCell] = GLCellManagerBus.collected_cells_refrence

	for cell: BrainCell in collected_cells:
		for stat_type: String in highest_clean_values.keys():
			var cell_stat: BrainCellStat = cell.get_stat(stat_type)

			if not cell_stat:
				push_error("Cell does not have a stat with type: " + stat_type)
				continue

			if not cell_stat.enabled:
				continue

			highest_clean_values[stat_type] = maxf(
				highest_clean_values[stat_type],
				cell_stat.value
			)

	# Advance locks using percentages of the available maximum.
	var ideal_stats: Array[IdealStat] = parent_ideal_stat_creator.get_ideal_stats()

	for ideal_stat: IdealStat in ideal_stats:
		var lock_index: int = _get_lock_index(ideal_stat.stat_type)
		lock_index = clampi(lock_index, 0, percentages.size() - 1)

		while (
			lock_index < percentages.size() - 1
			and highest_clean_values[ideal_stat.stat_type]
				> available_max_value * percentages[lock_index]
		):
			lock_index += 1

		_set_lock_index(ideal_stat.stat_type, lock_index)

		if lock_index == percentages.size() - 1:
			ideal_stat.lock_max_value = available_max_value
		else:
			ideal_stat.lock_max_value = (
				available_max_value * percentages[lock_index]
			)


func _get_lock_index(stat_type: String) -> int:
	match stat_type:
		"strength":
			return IVPrisonerProfiler.strength_stat_lock_percant_index
		"intelligence":
			return IVPrisonerProfiler.intelligence_stat_lock_percant_index
		"community":
			return IVPrisonerProfiler.community_stat_lock_percant_index
		_:
			push_error("Unknown stat type: " + stat_type)
			return 0


func _set_lock_index(stat_type: String, lock_index: int) -> void:
	match stat_type:
		"strength":
			IVPrisonerProfiler.strength_stat_lock_percant_index = lock_index
		"intelligence":
			IVPrisonerProfiler.intelligence_stat_lock_percant_index = lock_index
		"community":
			IVPrisonerProfiler.community_stat_lock_percant_index = lock_index
		_:
			push_error("Unknown stat type: " + stat_type)
