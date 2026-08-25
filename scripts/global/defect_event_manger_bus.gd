extends Node

# hidden stat interpreter 
signal event_hidden_stat_interpreter_jolt(selected_interpreters : Array)
signal stopped_jolt(interpreter_type : String) # important for event noticd

# cell container jolt event signal
signal initate_defect_event_cell_container(defect_event_type : String, cell_name : String, skip_event_notice : bool, data : Dictionary)

# prisoner extracted
signal prisoners_extracted(quanity : int)
signal cell_added_to_trashcan() # cells discareded early count too

# let admin panel know it finished
signal finished_trigger_event(finale_choice : String)
