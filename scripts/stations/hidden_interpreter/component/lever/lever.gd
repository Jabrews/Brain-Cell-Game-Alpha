extends InteractableBtn


@onready var lever_parent : Node3D = $".."

# called on ready
func _connect_signals():
	GLHoldingDisplayBus.connect('end_hold', _handle_end_hold)


func _on_btn_interacted():
	# make sure a interprer is jolting
	var jolt_possible : bool = verify_jolting_possible()
	if jolt_possible : 
		GLHoldingDisplayBus.emit_signal('start_hold', 3, 0.5, str(get_instance_id()))

func _handle_end_hold(hold_id : String, is_success : bool) :
	
	# make sure interprers are still jolting	
	if hold_id == str(get_instance_id()) :
		
		var jolt_possible : bool = verify_jolting_possible()
		
		if jolt_possible : 
			if is_success :
				var strength_interpreter : Node3D = lever_parent.strength_interpreter 
				var intelligence_interpreter : Node3D = lever_parent.intelligence_interpreter
				var community_interpreter : Node3D = lever_parent.community_interpreter 
				strength_interpreter._handle_defect_event_jolt_ended(true)
				intelligence_interpreter._handle_defect_event_jolt_ended(true)
				community_interpreter._handle_defect_event_jolt_ended(true)
				var strength_plugin : Node3D = lever_parent.strength_plugin
				var intelligence_plugin : Node3D = lever_parent.intelligence_plugin			
				var community_plugin : Node3D = lever_parent.community_plugin				
				strength_plugin._toggle_jolt(false)
				intelligence_plugin._toggle_jolt(false)
				community_plugin._toggle_jolt(false)
				
				
				


func verify_jolting_possible() -> bool : 
	
	var strength_interpreter : Node3D = lever_parent.strength_interpreter 
	var intelligence_interpreter : Node3D = lever_parent.intelligence_interpreter
	var community_interpreter : Node3D = lever_parent.community_interpreter 
	
	if strength_interpreter.jolt_active :
		return true
	if intelligence_interpreter.jolt_active : 
		return true
	if community_interpreter.jolt_active : 
		return true

	return false
	
	
	
	
	
