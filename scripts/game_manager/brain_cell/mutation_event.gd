extends Node


class_name MutationEvent

var event_name: String
var event_type : String

@warning_ignore("shadowed_variable")
func _init(
	event_name : String,
	event_type : String,
):
	self.event_name = event_name
	self.event_type = event_type

@warning_ignore("shadowed_global_identifier")
func _to_string() -> String:
	return "event name %s | event type: %s |" % [
		event_name,
		event_type,
	]
