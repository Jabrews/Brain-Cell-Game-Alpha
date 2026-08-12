extends Node


class_name MutationEvent

var event_name: String
var event_type : String
var mutation_name: String
var trigger_chance : int

@warning_ignore("shadowed_variable")
func _init(
	event_name : String,
	event_type : String,
	mutation_name: String,
	trigger_chance : int,
):
	self.event_name = event_name
	self.event_type = event_type
	self.mutation_name = mutation_name 
	self.trigger_chance = trigger_chance

@warning_ignore("shadowed_global_identifier")
func _to_string() -> String:
	return "event name %s | event type: %s | mutation name %s | trigger chance %s" % [
		event_name,
		event_type,
		mutation_name,
		trigger_chance,
	]
