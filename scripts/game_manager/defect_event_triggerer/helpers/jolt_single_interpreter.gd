extends Node


func _initate() -> void:
	var available_interpreters: Array[String] = []

	for interpreter_type: String in GLDefectEventMangerBus.interpreters_plugged_in:
		if GLDefectEventMangerBus.interpreters_plugged_in[interpreter_type]:
			available_interpreters.append(interpreter_type)

	if available_interpreters.is_empty():
		return

	var chosen_interpreter: String = available_interpreters.pick_random()

	GLDefectEventMangerBus.emit_signal(
		"event_hidden_stat_interpreter_jolt",
		[chosen_interpreter]
	)

	GLEventNoticeManagerBus.emit_signal(
		"create_event_notice",
		EventNotice.new(
			"defect_event",
			chosen_interpreter.to_upper() + " hidden stat interpreter jolting",
			{"interpreters": [chosen_interpreter]},
			1.0
		)
	)
