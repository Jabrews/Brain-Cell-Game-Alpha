extends Node


class_name BrainCellMutation

var type : String
var hidden : bool

@warning_ignore("shadowed_variable")
func _init(
	type : String,
	hidden : bool,
):
	self.type = type
	self.hidden = hidden


@warning_ignore("shadowed_global_identifier")
func _to_string() -> String:
	return "[Mutation] %s | hidden: %s " % [
		type,
		hidden,
	]
