extends Node


func _ready() -> void:
	GLPrisonerProfilerComponentsBus.connect(
		"request_new_profiler_spare_icons",
		_handle_request_new_profiler_spare_icons
	)
	

#func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed('debug1') :
		#IVPrisonerProfiler.strength_stat_lock_percant_index += 1
		#IVPrisonerProfiler.intelligence_stat_lock_percant_index += 1
		#IVPrisonerProfiler.community_stat_lock_percant_index += 1
		#_handle_request_new_profiler_spare_icons()
	


func _handle_request_new_profiler_spare_icons() -> void:
	var spare_icons: Array[SpareIconConstuctor] = []

	var stats: Array[String] = ["strength", "intelligence", "community"]
	stats.shuffle()

	var min_to_create: int = IVPrisonerProfiler.spare_symbol_minimum_created
	var max_to_create: int = IVPrisonerProfiler.spare_symbol_max_created
	var spare_symbols_available: Array = IVPrisonerProfiler.spare_symbols_avaible.duplicate()

	var amount_to_create: int = 0

	if max_to_create > 0:
		amount_to_create = min_to_create

		while amount_to_create < max_to_create:
			var ran_num: int = randi_range(1, 100)

			if ran_num >= 50:
				amount_to_create += 1
			else:
				break

	amount_to_create = clamp(amount_to_create, 0, stats.size())

	for i in range(stats.size()):
		var stat: String = stats[i]

		if i < amount_to_create:
			if spare_symbols_available.is_empty():
				push_error("No spare symbols available.")
				break

			var random_symbol_data: Dictionary = spare_symbols_available.pick_random()
			
			# remove from avaible symbol			
			spare_symbols_available.erase(random_symbol_data)

			var symbol_type: String = random_symbol_data.keys()[0]
			var symbol_direction: String = random_symbol_data[symbol_type].pick_random()

			var start_and_stop: Array[float] = pick_stop_start(
				symbol_type,
				symbol_direction,
				stat
			)

			spare_icons.append(
				SpareIconConstuctor.new(
					stat,
					symbol_type,
					symbol_direction,
					start_and_stop[0],
					start_and_stop[1]
				)
			)
		else:
			spare_icons.append(
				SpareIconConstuctor.new(
					stat,
					"none",
					"none",
					0.0,
					0.0
				)
			)

	GLPrisonerProfilerComponentsBus.emit_signal(
		"recieve_profiler_spare_icons",
		spare_icons
	)


func pick_stop_start(
	symbol_type: String,
	symbol_direction: String,
	stat_type: String
) -> Array[float]:
	var max_stat_value: float = get_max_stat_value(stat_type)

	var available_increments: Array[float] = get_available_increments(max_stat_value)

	var eligible_increments: Array[float] = get_eligible_increments(
		symbol_direction,
		available_increments,
		symbol_type,
	)

	return pick_range_from_increments(eligible_increments)


func get_max_stat_value(stat_type: String) -> float:
	var lock_index: int = 0

	match stat_type:
		"strength":
			lock_index = IVPrisonerProfiler.strength_stat_lock_percant_index
		"intelligence":
			lock_index = IVPrisonerProfiler.intelligence_stat_lock_percant_index
		"community":
			lock_index = IVPrisonerProfiler.community_stat_lock_percant_index
		_:
			push_error("Invalid stat type: " + stat_type)
			return 0.0

	var lock_percent: float = IVPrisonerProfiler.stat_lock_percantages[lock_index]
	var max_value: float = IVCellCreator.max_stat_value

	var max_stat_value: float = max_value * lock_percent
	max_stat_value = round(max_stat_value * 10.0) / 10.0

	return max_stat_value


func get_available_increments(lock_max: float) -> Array[float]:
	var available_increments: Array[float] = []

	# Always include 0.0 as the lowest possible range point.
	available_increments.append(0.0)

	var increment: float = IVPrisonerProfiler.stat_increment_amount
	var curr_value: float = 1.0

	while curr_value <= lock_max:
		var rounded_value: float = round(curr_value * 10.0) / 10.0
		available_increments.append(rounded_value)

		curr_value += increment

	var last_value: float = available_increments[available_increments.size() - 1]

	if last_value != lock_max:
		available_increments.append(lock_max)

	return available_increments


func get_eligible_increments(
	symbol_direction: String,
	available_increments: Array[float],
	symbol_type : String
) -> Array[float]:
	if available_increments.size() <= 2:
		return available_increments

	var eligible_increments: Array[float] = []

	var middle_index: int = int(floor((available_increments.size() - 1) / 2.0))

	
	symbol_direction = get_good_bad_symbol_direction(symbol_direction, symbol_type)


	match symbol_direction:
		"up":
			# Up symbols appear in the lower half.
			# Example: [0, 1, 2, 3, 4, 5, 6]
			# returns: [0, 1, 2, 3]
			for i in range(0, middle_index + 1):
				eligible_increments.append(available_increments[i])

		"down":
			# Down symbols appear in the upper half.
			# Example: [0, 1, 2, 3, 4, 5, 6]
			# returns: [3, 4, 5, 6]
			for i in range(middle_index, available_increments.size()):
				eligible_increments.append(available_increments[i])

		_:
			# If direction is unknown, use the full range.
			return available_increments

	return eligible_increments


func pick_range_from_increments(increments: Array[float]) -> Array[float]:
	if increments.is_empty():
		return [0.0, 0.0]

	if increments.size() == 1:
		return [increments[0], increments[0]]

	var increment_max: int = increments.size() - 1

	var min_gap: int = IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min
	var max_gap: int = IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max

	min_gap = max(1, min_gap)
	max_gap = max(min_gap, max_gap)

	# If the eligible range is too small, use the whole eligible range.
	if increment_max < min_gap:
		return [
			increments[0],
			increments[increment_max]
		]

	var gap: int = randi_range(min_gap, max_gap)
	gap = min(gap, increment_max)

	var start_index: int = randi_range(0, increment_max - gap)
	var stop_index: int = start_index + gap

	var start: float = increments[start_index]
	var stop: float = increments[stop_index]

	return [start, stop]


# kinda hacky helper
# just because up doesnt mean good in some cases
# however for interpeting the eligble increments : good = up
# therefore we must flip
func get_good_bad_symbol_direction(symbol_direction : String, symbol_type : String): 
	
	var flip_direction : bool = false
	
	if symbol_type == 'defect' :
		flip_direction = true
	elif symbol_type == 'bad_mutation' : 
		flip_direction = true
	
	if flip_direction : 
		if symbol_direction == 'up' :
			return 'down'
		else : 
			return 'up'
	
	else : 
		return symbol_direction
	
	
	
	
	
	
	
