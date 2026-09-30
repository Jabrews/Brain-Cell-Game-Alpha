extends Node

var current_defect_urgency_num: int = 0


#### CHANCES ####

# active values used by the event picker
var no_event_chance: int = 98

var cell_container_event_chance : int = 1 # BASE CHANCE
var container_bubble_chance: int = 1
var container_sickness_chance : int = 1

var jolt_interpreter_chance : int = 1 # BASE CHANCE
var jolt_all_interpreter_chance : int = 1

# WEIGHTS
var weight_increase_interpreter_jolt_chance : bool = false
var weight_active_interpreters : Array[String] = []
#################



# timer wait time
var defect_event_trigger_wait_time : float = 30.0
