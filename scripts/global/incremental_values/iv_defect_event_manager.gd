extends Node

# active values used by the event picker
var no_event_chance: int = 98
var jolt_cell_container_chance: int = 1
var jolt_hidden_stat_interpreter_chance: int = 1
var chance_for_multiple_hidden_stat_interpreter_jolt: int = 0

var max_defect_event_update_timer_duration = 10.0

var interpreter_jolt_defect_increase: int = 20
var cell_container_jolt_defect_increase: int = 20
var interpreter_jolt_energy_decrease_multiple = 1
var interpreter_jolt_energy_decrease_single = 2
	

var stats_to_hide: Array[String] = []
