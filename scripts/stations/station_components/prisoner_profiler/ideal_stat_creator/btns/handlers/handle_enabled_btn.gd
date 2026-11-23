extends Node

# components
@onready var parent_ideal_stat_creator : Node = $"../.."


func _handle() -> void:
	
	if not parent_ideal_stat_creator.enabled:
		GLPlayerLocalSoundsBus.emit_signal("sound_btn_press_failed")
		return
	
	var selected_stat : String = parent_ideal_stat_creator.selected_stat
	
	if selected_stat == 'none' or not selected_stat : 
		GLPlayerLocalSoundsBus.emit_signal("sound_btn_press_failed")
		return
	
	var selected_ideal_stat : IdealStat = parent_ideal_stat_creator.get_ideal_stat_bt_type(selected_stat)
	
	var new_toggle_value : bool = !selected_ideal_stat.enabled
		
	GLPrisonerProfilerComponentsBus.emit_signal('play_sound', 'on_off_click')

	#(ideal_stat_type : String, new_ideal_stat_enabled : bool) :
	parent_ideal_stat_creator._set_ideal_stat_enabled(selected_ideal_stat.stat_type, new_toggle_value)
