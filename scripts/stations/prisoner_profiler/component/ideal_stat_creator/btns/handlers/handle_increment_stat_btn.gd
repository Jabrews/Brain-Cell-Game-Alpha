extends Node

@onready var parent_ideal_stat_creator: Node = $"../.."


func _handle(increment_direction: String, holding_press: bool = false) -> void:
	
	## fail to increment events
	
	# 1.
	if not parent_ideal_stat_creator.enabled:
		_play_failed_sound(holding_press)
		return

	# 2.
	var selected_stat: String = parent_ideal_stat_creator.selected_stat
	if selected_stat == "none":
		_play_failed_sound(holding_press)
		return

	var increment: float
	match increment_direction:
		"up":
			increment = IVPrisonerProfiler.stat_increment_amount
		"down":
			increment = -IVPrisonerProfiler.stat_increment_amount
		_:
			_play_failed_sound(holding_press)
			push_error("Invalid increment direction: " + increment_direction)
			return

	var ideal_stat: IdealStat = parent_ideal_stat_creator.get_ideal_stat_bt_type(selected_stat)
	
	# 3.
	if ideal_stat == null:
		_play_failed_sound(holding_press)
		push_error("Could not find IdealStat for: " + selected_stat)
		return

	# 4.
	var max_stat_value: float = IVCellCreator.max_stat_value
	if max_stat_value <= 0.0:
		push_error("max_stat_value must be greater than 0.")
		return

	var current_value: float = ideal_stat.value
	var new_value: float = clampf(
		current_value + increment,
		0.0,
		max_stat_value
	)

	# deal with one interval before lock
	var lock_value: float = ideal_stat.lock_max_value
	
	# check if it surpasses lock
	if new_value >= lock_value : 
		
		var before_lock_found : bool = false
		
		# make sure before this happen that it was acutally behinde the lock
		if lock_value - increment > current_value :
			before_lock_found = true
		 # because we include .15 (the tenth) in stat lock percantages 
		elif lock_value - increment / 2 > current_value : 
			before_lock_found = true
	
		if before_lock_found : 
			new_value = ideal_stat.lock_max_value - 1.0
		


	if holding_press:
		GLPrisonerProfilerComponentsBus.emit_signal(
			"play_sound",
			"increment_hold"
		)
	else:
		GLPrisonerProfilerComponentsBus.emit_signal(
			"play_sound",
			"increment"
		)

	parent_ideal_stat_creator._set_ideal_stat_value(
		selected_stat,
		new_value
	)


func _play_failed_sound(holding_press: bool) -> void:
	if not holding_press:
		GLPlayerLocalSoundsBus.emit_signal("sound_btn_press_failed")
