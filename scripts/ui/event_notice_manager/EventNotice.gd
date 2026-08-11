extends Node

class_name EventNotice

var event_type : String
var event_body_text : String

@warning_ignore("shadowed_variable")
func _init(
	event_type : String,
	event_body_text : String,
) -> void:
	self.event_type = event_type	
	self.event_body_text = event_body_text


func _to_string() -> String:
	return "[event notice] %s | event type: %s | event body text: %s" % [
		event_type,
		event_body_text,
	]
	
	
	
	

	
