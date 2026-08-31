extends Node


func _initate_defect_event(): 
	
	
	if GameAdminPanel.enabled:
		GLDefectEventMangerBus.emit_signal(
			"finished_trigger_event",
			"cell-sickness-chance"
		)
	
	# dont jolt if no stats to hide (round 1)	
	if len(IVHiddenStats.stats_to_hide) == 0 :
		return
	
	var avaible_interpreters_to_jolt : Array[String] = IVHiddenStats.stats_to_hide.duplicate()
	
	var interpreters_plugged_in : Dictionary[String, bool] = GLDefectEventMangerBus.interpreters_plugged_in.duplicate()
	for interpreter_type : String in interpreters_plugged_in : 
		# if its not plugged in. erase from avaible
		if interpreters_plugged_in[interpreter_type] == false : 
			avaible_interpreters_to_jolt.erase(interpreter_type)
	
	if len(avaible_interpreters_to_jolt) <= 0 : 
		if GameAdminPanel.enabled:
			GLDefectEventMangerBus.emit_signal(
				"finished_trigger_event",
				"none"
			)
		return
	
	if len(avaible_interpreters_to_jolt) == 1 :
		decide_single_stat_interpreter(avaible_interpreters_to_jolt)
		return
	
	# random num (1 - 100)
	var ran_num = randi_range(1, 100)
	var all_jolt_chance = IVDefectEventManager.jolt_all_interpreter_chance
	
	# all jolt
	if ran_num <= all_jolt_chance : 
		
		GLDefectEventMangerBus.emit_signal(
			"event_hidden_stat_interpreter_jolt",
			avaible_interpreters_to_jolt,
		)
		
		GLPlayerLocalSoundsBus.emit_signal('sound_hidden_stat_interpreter_all_jolt')
		
		GLEventNoticeManagerBus.emit_signal('create_event_notice', 
			EventNotice.new('defect_event', 'ALL hidden stat interpreters jolting', {'interpreters' : avaible_interpreters_to_jolt.duplicate()} , 1.5)
		)
		
		# admin stuff
		if GameAdminPanel.enabled:
			GLDefectEventMangerBus.emit_signal(
				"finished_trigger_event",
				'interpreter-all-' + str(all_jolt_chance)
			)
		
	# single jolt
	else:
		decide_single_stat_interpreter(avaible_interpreters_to_jolt)


func decide_single_stat_interpreter(avaible_interpreters_to_jolt : Array[String]) -> void:
	
	
	var chosen_single_interpreter : String = ''
	
	if IVDefectEventManager.weight_active_interpreters :
		var weight_interpreters : Array[String] = []
		
		for interpreter_type : String in IVDefectEventManager.weight_active_interpreters :
			if interpreter_type in avaible_interpreters_to_jolt :
				weight_interpreters.append(interpreter_type)
		
		if len(weight_interpreters) > 0 : 
			chosen_single_interpreter = weight_interpreters.pick_random()
		else : 
			chosen_single_interpreter = avaible_interpreters_to_jolt.pick_random()
	else : 
		chosen_single_interpreter = avaible_interpreters_to_jolt.pick_random()
	
	match chosen_single_interpreter :
		'strength' :
			GLDefectEventMangerBus.emit_signal('event_hidden_stat_interpreter_jolt', ['strength'])
		'intelligence':
			GLDefectEventMangerBus.emit_signal('event_hidden_stat_interpreter_jolt', ['intelligence'])
		'community' :
			GLDefectEventMangerBus.emit_signal('event_hidden_stat_interpreter_jolt', ['community'])
		_ :
			print('unable to find random stat : ', chosen_single_interpreter)
	
	GLEventNoticeManagerBus.emit_signal('create_event_notice', 
		EventNotice.new('defect_event', chosen_single_interpreter.to_upper() + ' hidden stat interpreter jolting', {'interpreters' : [chosen_single_interpreter]}, 1.0)		
	)
	
	if GameAdminPanel.enabled:
		GLDefectEventMangerBus.emit_signal(
			"finished_trigger_event",
			'interpreter-single'
		)
