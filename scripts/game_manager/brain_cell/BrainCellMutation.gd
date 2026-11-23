extends Node

class_name BrainCellMutation

var type: String
var hidden: bool
var mutation_events: Array[MutationEvent]


@warning_ignore("shadowed_variable")
func _init(
	type: String,
	hidden: bool,
	mutation_events: Array[MutationEvent] = [],
) -> void:
	self.type = type
	self.hidden = hidden
	self.mutation_events = mutation_events


@warning_ignore("shadowed_global_identifier")
func _to_string() -> String:
	return "[Mutation] %s | hidden: %s | mutation events: %s" % [
		type,
		hidden,
		mutation_events,
	]
