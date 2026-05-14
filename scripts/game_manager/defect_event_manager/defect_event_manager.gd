extends Node

# components
@onready var defect_event_update_timer : Timer = $DefectEventUpdateTimer
@onready var jolt_hidden_stat_interpreter : Node = $JoltHiddenStatInterpreter
@onready var jolt_cell_container : Node = $JoltCellContainer

func _ready() -> void:
	defect_event_update_timer.connect("timeout", _on_defect_event_update_timer_timeout)
	defect_event_update_timer.start()


func _on_defect_event_update_timer_timeout() -> void:
	
	var no_event_chance = IVDefectEventManager.no_event_chance
	var jolt_cell_container_chance = IVDefectEventManager.jolt_cell_container_chance
	var jolt_hidden_stat_interpreter_chance = IVDefectEventManager.jolt_hidden_stat_interpreter_chance

	var ran_num = randi_range(1, 100)

	if ran_num <= no_event_chance:
		# no event
		pass

	elif ran_num <= no_event_chance + jolt_hidden_stat_interpreter_chance:
		# jolt hidden stat interpreter
		jolt_hidden_stat_interpreter._handle_jolt()

	elif ran_num <= (
		no_event_chance
		+ jolt_hidden_stat_interpreter_chance
		+ jolt_cell_container_chance
	):
		# jolt cell container
		pass
	
 
