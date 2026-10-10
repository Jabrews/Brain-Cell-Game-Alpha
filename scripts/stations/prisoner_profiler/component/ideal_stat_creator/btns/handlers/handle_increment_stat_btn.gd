extends Node

@onready var parent_ideal_stat_creator: Node = $"../.."


func _handle(increment_direction: String, holding_press: bool = false) -> void:
	if not parent_ideal_stat_creator.enabled:
		_play_failed_sound(holding_press)
		return

	var selected_stat: String = parent_ideal_stat_creator.selected_stat
	if selected_stat == "none":
		_play_failed_sound(holding_press)
		return

	var increment: float
	match increment_direction:
		"up":
			increment = 10.0
		"down":
			increment = -10.0
		_:
			_play_failed_sound(holding_press)
			push_error("Invalid increment direction: " + increment_direction)
			return

	var ideal_stat: IdealStat = (
		parent_ideal_stat_creator.get_ideal_stat_bt_type(selected_stat)
	)
	if ideal_stat == null:
		_play_failed_sound(holding_press)
		push_error("Could not find IdealStat for: " + selected_stat)
		return

	var max_stat_value: float = IVCellCreator.max_stat_value
	if max_stat_value <= 0.0:
		push_error("max_stat_value must be greater than 0.")
		return

	var new_value: float = clampf(
		ideal_stat.value + increment,
		0.0,
		max_stat_value
	)

	if is_equal_approx(new_value, ideal_stat.value):
		_play_failed_sound(holding_press)
		return

	if not holding_press : 
		GLPrisonerProfilerComponentsBus.emit_signal("play_sound", "increment")
	else : 
		GLPrisonerProfilerComponentsBus.emit_signal("play_sound", "increment_hold")
	parent_ideal_stat_creator._set_ideal_stat_value(selected_stat, new_value)


func _play_failed_sound(holding_press: bool) -> void:
	if not holding_press:
		GLPlayerLocalSoundsBus.emit_signal("sound_btn_press_failed")
