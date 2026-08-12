extends Node

class_name EventNotice

var event_type : String
var event_body_text : String
var data : Dictionary
var wait_time_overide : float

@warning_ignore("shadowed_variable")
func _init(
	event_type : String,
	event_body_text : String,
	data : Dictionary,
	wait_time_overide : float = 0.0,
) -> void:
	self.event_type = event_type	
	self.event_body_text = event_body_text
	self.data = data
	self.wait_time_overide = wait_time_overide


func _to_string() -> String:
	return "[event notice] | event type: %s | event body text: %s | misc data : %s | Wait time overide (none : 0.0 ) : %s" % [
		event_type,
		event_body_text,
		data,
		wait_time_overide,
	]
	
	
	
	

	
