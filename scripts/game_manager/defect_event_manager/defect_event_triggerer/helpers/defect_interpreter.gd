extends Node


func _initate_defect_event() -> void:
	# Don't jolt interpreters if there are no stats to hide.
	if IVHiddenStats.stats_to_hide.is_empty():
		return

	var available_interpreters: Array[String] = (
		IVHiddenStats.stats_to_hide.duplicate()
	)

	var interpreters_plugged_in: Dictionary[String, bool] = (
		GLDefectEventMangerBus.interpreters_plugged_in.duplicate()
	)

	for interpreter_type: String in interpreters_plugged_in:
		if not interpreters_plugged_in[interpreter_type]:
			available_interpreters.erase(interpreter_type)

	if available_interpreters.is_empty():
		return

	if available_interpreters.size() == 1:
		decide_single_stat_interpreter(available_interpreters)
		return

	var random_number: int = randi_range(1, 100)
	var all_jolt_chance: int = IVDefectEventManager.jolt_all_interpreter_chance

	if random_number <= all_jolt_chance:
		GLDefectEventMangerBus.emit_signal(
			"event_hidden_stat_interpreter_jolt",
			available_interpreters
		)

		GLPlayerLocalSoundsBus.emit_signal(
			"sound_hidden_stat_interpreter_all_jolt"
		)

		GLEventNoticeManagerBus.emit_signal(
			"create_event_notice",
			EventNotice.new(
				"defect_event",
				"ALL hidden stat interpreters jolting",
				{"interpreters": available_interpreters.duplicate()},
				1.5
			)
		)
	else:
		decide_single_stat_interpreter(available_interpreters)


func decide_single_stat_interpreter(
	available_interpreters: Array[String]
) -> void:
	var chosen_interpreter: String = ""

	if not IVDefectEventManager.weight_active_interpreters.is_empty():
		var weighted_interpreters: Array[String] = []

		for interpreter_type: String in IVDefectEventManager.weight_active_interpreters:
			if interpreter_type in available_interpreters:
				weighted_interpreters.append(interpreter_type)

		if not weighted_interpreters.is_empty():
			chosen_interpreter = weighted_interpreters.pick_random()
		else:
			chosen_interpreter = available_interpreters.pick_random()
	else:
		chosen_interpreter = available_interpreters.pick_random()

	match chosen_interpreter:
		"strength", "intelligence", "community":
			GLDefectEventMangerBus.emit_signal(
				"event_hidden_stat_interpreter_jolt",
				[chosen_interpreter]
			)
		_:
			push_warning(
				"Unable to find a valid stat interpreter: " + chosen_interpreter
			)
			return

	GLEventNoticeManagerBus.emit_signal(
		"create_event_notice",
		EventNotice.new(
			"defect_event",
			chosen_interpreter.to_upper() + " hidden stat interpreter jolting",
			{"interpreters": [chosen_interpreter]},
			1.0
		)
	)
