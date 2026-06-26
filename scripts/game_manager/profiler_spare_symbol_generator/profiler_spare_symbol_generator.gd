extends Node


func _ready() -> void:
	GLPrisonerProfilerComponentsBus.connect("request_new_profiler_spare_icons", _handle_request_new_profiler_spare_icons )



func _handle_request_new_profiler_spare_icons() -> void:
	var spare_icons := {
		"strength": {
			"type": "none",
			"direction": "none",
			'start' : 0,
			'stop' : 0,
		},
		"intelligence": {
			"type": "none",
			"direction": "none",
			'start' : 0,
			'stop' : 0,
		},
		"community": {
			"type": "none",
			"direction": "none",
			'start' : 0,
			'stop' : 0,
		},
	}

	var min_to_create: int = IVPrisonerProfiler.spare_symbol_minimum_created
	var max_to_create: int = IVPrisonerProfiler.spare_symbol_max_created
	var spare_symbols_available: Array = IVPrisonerProfiler.spare_symbols_avaible

	if max_to_create <= 0:
		GLPrisonerProfilerComponentsBus.emit_signal(
			"recieve_profiler_spare_icons",
			spare_icons
		)
		return

	var stats := ["strength", "intelligence", "community"]
	stats.shuffle()

	var amount_to_create: int = min_to_create

	while amount_to_create < max_to_create:
		var ran_num := randi_range(0, 100)

		if ran_num >= 50:
			amount_to_create += 1
		else:
			break

	amount_to_create = clamp(amount_to_create, 0, stats.size())

	for i in amount_to_create:
		var stat: String = stats[i]

		var random_symbol_data: Dictionary = spare_symbols_available.pick_random()

		var symbol_type: String = random_symbol_data.keys()[0]
		var symbol_direction: String = random_symbol_data[symbol_type].pick_random()
		var start_and_stop : Array[float] = pick_stop_start(stats[i])

		spare_icons[stat] = {
			"type": symbol_type,
			"direction": symbol_direction,
			'start' : start_and_stop[0],
			'stop' : start_and_stop[1],
		}

	GLPrisonerProfilerComponentsBus.emit_signal(
		"recieve_profiler_spare_icons",
		spare_icons
	)

func pick_stop_start(stat_type: String) -> Array[float]:
	var max_stat_value: float = IVCellCreator.max_stat_value
	var lock_percentages: Array[float] = IVPrisonerProfiler.stat_lock_percantages

	var percentage_index: int

	match stat_type:
		"strength":
			percentage_index = IVPrisonerProfiler.strength_stat_lock_percant_index
		"intelligence":
			percentage_index = IVPrisonerProfiler.intelligence_stat_lock_percant_index
		"community":
			percentage_index = IVPrisonerProfiler.community_stat_lock_percant_index
		_:
			push_error("Invalid stat type: " + stat_type)
			return [0.0, 0.0]

	var lock_max: float = max_stat_value * lock_percentages[percentage_index]
	var minimum_range: float = 100.0

	if lock_max < minimum_range:
		return [0.0, lock_max]

	# Pick max first. It cannot be lower than 100.
	var stat_max: float = randf_range(minimum_range, lock_max)
	stat_max = round(stat_max * 10.0) / 10.0

	# Min must be at least 100 below max.
	var highest_possible_min: float = stat_max - minimum_range
	var stat_min: float = randf_range(0.0, highest_possible_min)
	stat_min = round(stat_min * 10.0) / 10.0

	return [stat_min, stat_max]
	
	
	
	
	
	
