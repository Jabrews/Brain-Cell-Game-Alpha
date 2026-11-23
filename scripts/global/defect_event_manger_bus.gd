extends Node

# hidden stat interpreter 
signal event_hidden_stat_interpreter_jolt(selected_interpreters : Array)
signal stopped_jolt(interpreter_type : String) # important for event noticd

# cell container jolt event signal
signal initate_defect_event_cell_container(defect_event_type : String, cell_name : String, skip_event_notice : bool, data : Dictionary)

var interpreters_plugged_in : Dictionary[String, bool]  = {
	'strength' : true,
	'intelligence' : true,
	'community' : true,	
}
