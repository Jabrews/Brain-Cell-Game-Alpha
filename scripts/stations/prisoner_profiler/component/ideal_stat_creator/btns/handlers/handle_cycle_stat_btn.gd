extends Node

# components
@onready var parent_ideal_stat_creator : Node = $"../.."


func _handle(cycle_direction: String) -> void:
	if not parent_ideal_stat_creator.enabled:
		GLPlayerLocalSoundsBus.emit_signal("sound_btn_press_failed")
		return
	
	GLPrisonerProfilerComponentsBus.emit_signal('play_sound', 'cycle_stat')

	var direction_increment: int
	match cycle_direction:
		"up":
			direction_increment = -1
		"down":
			direction_increment = 1
		_:
			push_error("Unable to find cycle direction: " + cycle_direction)
			return

	var possible_selected_stats: Array[String] = parent_ideal_stat_creator.possible_selected_stats

	if possible_selected_stats.is_empty():
		push_error("Cannot cycle stats: possible_selected_stats is empty.")
		return

	var selected_stat_index: int = parent_ideal_stat_creator.selected_stat_index
	var next_stat_index: int = posmod(
		selected_stat_index + direction_increment,
		possible_selected_stats.size()
	)

	# set in parent
	parent_ideal_stat_creator._set_selected_stat(possible_selected_stats[next_stat_index], next_stat_index)
