extends Node

# components
@onready var handle_spare_symbols: Node = $".."
@onready var handle_spare_symbols_effects: Node = $"../SpareSymbolEffects"
@onready var profiler_audio_manager: Node3D = $"../../../../ProfilerAudioManager"
@onready var parent_prisoner_profiler: Node3D = $"../../../.."

var spare_active_by_stat: Dictionary = {
	"strength": false,
	"intelligence": false,
	"community": false,
}


func _handle_value_changed(selected_stat: String, new_value: float, _old_value: float) -> void:
	var selected_spare_icon_constructor: SpareIconConstuctor = _get_spare_icon_constructor(selected_stat)

	if selected_spare_icon_constructor == null:
		push_error("Unable to find spare icon constructor for stat: " + selected_stat)
		return

	if selected_spare_icon_constructor.type == "none":
		spare_active_by_stat[selected_stat] = false
		return

	var new_value_in_range: bool = evaluate_num_in_range(
		new_value,
		selected_spare_icon_constructor.start,
		selected_spare_icon_constructor.stop
	)

	var spare_was_active: bool = spare_active_by_stat.get(selected_stat, false)

	# No state change, so do nothing.
	if new_value_in_range == spare_was_active:
		return

	# Enter area.
	if new_value_in_range:
		spare_active_by_stat[selected_stat] = true
		_activate_spare_symbol(selected_spare_icon_constructor, true)

	# Exit area.
	else:
		spare_active_by_stat[selected_stat] = false
		_deactivate_spare_symbol(selected_spare_icon_constructor, true)


func _refresh_safe_mode_disabled() -> void:
	_refresh_spare_icon_current_state(
		"strength",
		parent_prisoner_profiler.strength_enabled,
		parent_prisoner_profiler.strength_value
	)

	_refresh_spare_icon_current_state(
		"intelligence",
		parent_prisoner_profiler.intelligence_enabled,
		parent_prisoner_profiler.intelligence_value
	)

	_refresh_spare_icon_current_state(
		"community",
		parent_prisoner_profiler.community_enabled,
		parent_prisoner_profiler.community_value
	)

func _refresh_spare_icon_current_state(stat: String, stat_enabled: bool, stat_value: float) -> void:
	var selected_spare_icon_constructor: SpareIconConstuctor = _get_spare_icon_constructor(stat)

	if selected_spare_icon_constructor == null:
		push_error("Unable to find spare icon constructor for stat: " + stat)
		return

	if selected_spare_icon_constructor.type == "none":
		spare_active_by_stat[stat] = false
		handle_spare_symbols_effects._activate(false, selected_spare_icon_constructor)
		return

	if not stat_enabled:
		spare_active_by_stat[stat] = false
		handle_spare_symbols_effects._activate(false, selected_spare_icon_constructor)
		return

	var value_in_range: bool = evaluate_num_in_range(
		stat_value,
		selected_spare_icon_constructor.start,
		selected_spare_icon_constructor.stop
	)

	spare_active_by_stat[stat] = value_in_range

	if value_in_range:
		_activate_spare_symbol(selected_spare_icon_constructor, false)
	else:
		_deactivate_spare_symbol(selected_spare_icon_constructor, false)


func _activate_spare_symbol(
	selected_spare_icon_constructor: SpareIconConstuctor,
	play_audio: bool
) -> void:
	if play_audio:
		profiler_audio_manager.play_spare_enter()

	GLPrisonerProfilerComponentsBus.emit_signal(
		"station_feedback_requested",
		"spare_label",
		{"data": selected_spare_icon_constructor}
	)

	GLPrisonerProfilerComponentsBus.emit_signal(
		"station_feedback_requested",
		"spare_icon",
		{
			"data": {
				"icon_type": selected_spare_icon_constructor.type,
				"stat_type": selected_spare_icon_constructor.stat
			}
		}
	)

	handle_spare_symbols_effects._activate(true, selected_spare_icon_constructor)


func _deactivate_spare_symbol(
	selected_spare_icon_constructor: SpareIconConstuctor,
	play_audio: bool
) -> void:
	if play_audio:
		profiler_audio_manager.play_spare_exit()

	handle_spare_symbols_effects._activate(false, selected_spare_icon_constructor)


func _get_spare_icon_constructor(stat: String) -> SpareIconConstuctor:
	var spare_icon_constructors: Array[SpareIconConstuctor] = handle_spare_symbols.selected_spare_icon_constructors

	for spare_icon_constructor: SpareIconConstuctor in spare_icon_constructors:
		if spare_icon_constructor.stat == stat:
			return spare_icon_constructor

	return null


func evaluate_num_in_range(num: float, min_num: float, max_num: float) -> bool:
	return num >= min_num and num <= max_num


func _reset_spare_active_states() -> void:
	spare_active_by_stat["strength"] = false
	spare_active_by_stat["intelligence"] = false
	spare_active_by_stat["community"] = false
