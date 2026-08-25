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
	
	if len(IVHiddenStats.stats_to_hide) == 1 :
		decide_single_stat_interpreter()
		return
	
	# random num (1 - 100)
	var ran_num = randi_range(1, 100)
	var all_jolt_chance = IVDefectEventManager.jolt_all_interpreter_chance
	
	# ALL JOLT 
	if ran_num <= all_jolt_chance : 
		GLDefectEventMangerBus.emit_signal(
			"event_hidden_stat_interpreter_jolt",
			IVHiddenStats.stats_to_hide,
		)
		
		GLPlayerLocalSoundsBus.emit_signal('sound_hidden_stat_interpreter_all_jolt')
		
		GLEventNoticeManagerBus.emit_signal('create_event_notice', 
			EventNotice.new('defect_event', 'ALL hidden stat interpreters jolting', {'interpreters' : IVHiddenStats.stats_to_hide.duplicate()} , 1.5)
		)
		
		# admin stuff
		if GameAdminPanel.enabled:
			GLDefectEventMangerBus.emit_signal(
				"finished_trigger_event",
				'interpreter-all-' + str(all_jolt_chance)
			)
		
	# SINGLE JOLT
	else:
		decide_single_stat_interpreter()
	

func decide_single_stat_interpreter() -> void:
	
	
	var chosen_single_interpreter : String	= ''
	
	if IVDefectEventManager.weight_active_interpreters :
		var weight_interpreters : Array[String] = IVDefectEventManager.weight_active_interpreters
		if len(weight_interpreters) > 0 : 
			chosen_single_interpreter = weight_interpreters.pick_random()
	else : 
		var stats_to_hide = IVHiddenStats.stats_to_hide	
		chosen_single_interpreter = stats_to_hide.pick_random()
	
	match  chosen_single_interpreter :
		'strength' :
			GLDefectEventMangerBus.emit_signal('event_hidden_stat_interpreter_jolt', ['strength'])

		'intelligence':
			GLDefectEventMangerBus.emit_signal('event_hidden_stat_interpreter_jolt', ['intelligence'])
		'community' :
			GLDefectEventMangerBus.emit_signal('event_hidden_stat_interpreter_jolt', ['community'])
		_ :
			print('undable to find random stat : ', chosen_single_interpreter)
	
	GLEventNoticeManagerBus.emit_signal('create_event_notice', 
		EventNotice.new('defect_event', chosen_single_interpreter.to_upper() + ' hidden stat interpreter jolting', {'interpreters' : [chosen_single_interpreter]}, 1.0)		
	)
	
	# admin stuff
	if GameAdminPanel.enabled:
		GLDefectEventMangerBus.emit_signal(
			"finished_trigger_event",
			'interpreter-single'
		)
	
	
	
	
	
	
	
