extends Node

@onready var parent_ideal_stat_creator: Node = $"../.."


func _handle(increment_direction: String) -> void:
	if not parent_ideal_stat_creator.enabled:
		GLPlayerLocalSoundsBus.emit_signal("sound_btn_press_failed")
		return

	var selected_stat: String = parent_ideal_stat_creator.selected_stat
	if selected_stat == "none":
		GLPlayerLocalSoundsBus.emit_signal("sound_btn_press_failed")
		return

	var ideal_value_increment: float
	match increment_direction:
		"up":
			ideal_value_increment = 10.0
		"down":
			ideal_value_increment = -10.0
		_:
			GLPlayerLocalSoundsBus.emit_signal("sound_btn_press_failed")
			push_error("Invalid increment direction: " + increment_direction)
			return

	var selected_ideal_stat: IdealStat = parent_ideal_stat_creator.get_ideal_stat_bt_type(selected_stat)
	
	if selected_ideal_stat == null:
		GLPlayerLocalSoundsBus.emit_signal("sound_btn_press_failed")
		return

	var new_ideal_stat_value: float = selected_ideal_stat.value + ideal_value_increment

	GLPlayerLocalSoundsBus.emit_signal("sound_btn_press_success")
	parent_ideal_stat_creator._set_ideal_stat_value(
		selected_stat,
		new_ideal_stat_value
	)
