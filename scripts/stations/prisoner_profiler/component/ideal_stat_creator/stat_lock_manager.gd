extends Node

@onready var parent_ideal_stat_creator: Node = $".."

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') :
		_initate_new_stat_locks()
		var str_ideal_stat : IdealStat = parent_ideal_stat_creator.strength_ideal_stat
		print('strength lock max value : ', str_ideal_stat.lock_max_value)
		print('strength lock index : ', IVPrisonerProfiler.strength_stat_lock_percant_index)


func _initate_new_stat_locks() -> void:
	var max_value: float = IVCellCreator.max_stat_value
	var percentages: Array[float] = IVPrisonerProfiler.stat_lock_percantages

	if max_value <= 0.0:
		push_error("max_stat_value must be greater than 0.")
		return

	if percentages.is_empty():
		push_error("stat_lock_percantages is empty.")
		return


	## 1. look through each collected cell and tally up highest clean value in al
	var highest_clean_values: Dictionary[String, float] = {
		"strength": 0.0,
		"intelligence": 0.0,
		"community": 0.0,
	}

	var collected_cells: Array[BrainCell] = GLCellManagerBus.collected_cells_refrence

	for cell: BrainCell in collected_cells:
		
		for stat_type: String in highest_clean_values.keys():
			
			var cell_stat : BrainCellStat = cell.get_stat(stat_type)
			
			if not cell_stat : 
				push_error('cell doesnt have a stat with type : ', stat_type)
				continue
			
			if not cell_stat.enabled: 
				continue
			
			# NOTE
			# POSSIBLY GOOD IDEA HERE IF LOCKS GO WAY TOO QUICK
			#var clean_value: float = maxf(
				#cell_stat.value - cell_stat.defect,
				#0.0
			#)

			highest_clean_values[stat_type] = maxf(
				highest_clean_values[stat_type],
				cell_stat.value, # or clean_value
			)

	## 2. look at current index total_value * stat_percantage. 
	## 3. if it does exceed it, start at that index and increment to next stat_percantage and see if it passed
	## 4. if it doesnt exeeced it set the new current stat percantage and return/continue through stats


	var ideal_stats: Array[IdealStat] = parent_ideal_stat_creator.get_ideal_stats()

	for ideal_stat: IdealStat in ideal_stats:
		var lock_index: int = _get_lock_index(ideal_stat.stat_type)
		lock_index = clampi(lock_index, 0, percentages.size() - 1)

		while (
			lock_index < percentages.size() - 1
			and highest_clean_values[ideal_stat.stat_type]
				> max_value * percentages[lock_index]
		):
			lock_index += 1

		_set_lock_index(ideal_stat.stat_type, lock_index)
		
		# check if 100% complete
		# if so then just set to max value
		if lock_index >= percentages.size() - 1 :
			ideal_stat.lock_max_value = IVCellCreator.max_stat_value
		
		# other wise set lock value with lock index
		else : 
			ideal_stat.lock_max_value = max_value * percentages[lock_index]


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
