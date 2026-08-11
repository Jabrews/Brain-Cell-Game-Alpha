extends Node



func _handle_jolt() :
	
	# dont jolt if no stats to hide (round 1)	
	if len(IVHiddenStats.stats_to_hide) == 0 :
		return
	
	# random num (1 - 100)
	var ran_num = randi_range(1, 100)
	var all_jolt_chance = IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt
	
	# all interpreters jolt
	if ran_num <= all_jolt_chance:
		
		
		GLDefectEventMangerBus.emit_signal(
			"event_hidden_stat_interpreter_jolt",
			IVHiddenStats.stats_to_hide,
		)
		
		GLEventNoticeManagerBus.emit_signal('create_event_notice', 
			EventNotice.new('defect_event', 'ALL hidden stat interpreters jolting')		
		)
		
		# emit sound
		GLPlayerLocalSoundsBus.emit_signal('sound_hidden_stat_interpreter_all_jolt')
	
	# single interpreter jolt
	else:
		decide_single_stat_interpreter()
	

func decide_single_stat_interpreter() -> void:
	
	var stats_to_hide = IVHiddenStats.stats_to_hide	
	
	var random_stat = stats_to_hide.pick_random()
	
	match  random_stat :
		'strength' :
			GLDefectEventMangerBus.emit_signal('event_hidden_stat_interpreter_jolt', ['strength'])

		'intelligence':
			GLDefectEventMangerBus.emit_signal('event_hidden_stat_interpreter_jolt', ['intelligence'])
		'community' :
			GLDefectEventMangerBus.emit_signal('event_hidden_stat_interpreter_jolt', ['community'])
		_ :
			print('undable to find random stat : ', random_stat)
	
	GLEventNoticeManagerBus.emit_signal('create_event_notice', 
		EventNotice.new('defect_event', random_stat.to_upper() + ' hidden stat interpreter jolting')		
	)
	
	
	
	
	
	
	
