extends Node


func _initate() -> void:
	var selected_interpreters: Array[String] = []

	for interpreter_type: String in GLDefectEventMangerBus.interpreters_plugged_in:
		if GLDefectEventMangerBus.interpreters_plugged_in[interpreter_type]:
			selected_interpreters.append(interpreter_type)

	if selected_interpreters.is_empty():
		return

	GLDefectEventMangerBus.emit_signal(
		"event_hidden_stat_interpreter_jolt",
		selected_interpreters
	)

	GLPlayerLocalSoundsBus.emit_signal(
		"sound_hidden_stat_interpreter_all_jolt"
	)

	GLEventNoticeManagerBus.emit_signal(
		"create_event_notice",
		EventNotice.new(
			"defect_event",
			"ALL hidden stat interpreters jolting",
			{"interpreters": selected_interpreters.duplicate()},
			1.5
		)
	)
