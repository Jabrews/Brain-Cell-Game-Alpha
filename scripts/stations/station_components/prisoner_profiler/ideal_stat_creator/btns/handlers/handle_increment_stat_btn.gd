extends Node

@onready var parent_ideal_stat_creator: Node = $"../.."
@onready var energy_manager : Node = $"../../EnergyManager"


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
	
	# get current and new values
	var current_value: float = ideal_stat.value
	var new_value: float = clampf(
		current_value + increment,
		0.0,
		max_stat_value
	)
	
	# deal with one interval before lock
		
	var lock_value: float = ideal_stat.lock_max_value
	var unreachable_min_value: float = IVPrisonerProfiler.uncreachable_min_value

	var lock_active: bool = (
		lock_value < unreachable_min_value
		and not is_equal_approx(lock_value, unreachable_min_value)
	)

	if lock_active:
		if new_value >= lock_value:
			var before_lock_found: bool = (
				lock_value - increment > current_value
				or lock_value - increment / 2.0 > current_value
			)

			if before_lock_found:
				new_value = lock_value - 5.0 #1

		if new_value >= lock_value:
			GLPrisonerProfilerComponentsBus.emit_signal("display_feedback", "lock_alert", {"stat": ideal_stat.stat_type})
			return

	# Deal with one interval before the unreachable region.
	if new_value >= unreachable_min_value:
		var before_unreachable_found: bool = (
			unreachable_min_value - increment > current_value
			or unreachable_min_value - increment / 2.0 > current_value
		)

		if before_unreachable_found:
			new_value = unreachable_min_value - 5.0 #1

	if new_value > unreachable_min_value:
		GLPrisonerProfilerComponentsBus.emit_signal("play_sound", "unreachable_alert")
		return
	
	
	# update increments used (used in energy)
	if new_value != current_value : 
		
		match increment_direction : 
			'up' :
				ideal_stat.increments_used += 1
								# check if we've just surpassed max energy with it all spent
				# ONLT EXIST IN UP INCREMENT
				var total_energy_spent : int = energy_manager._get_total_energy_spent()
				if parent_ideal_stat_creator.total_energy + total_energy_spent == 0 : 
					GLPrisonerProfilerComponentsBus.emit_signal('display_feedback', 'alert_invalid_energy_left', {})
				
				
			'down' :
				ideal_stat.increments_used -= 1
	

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
