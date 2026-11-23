extends Node

class_name FileInfo

var type : String
var seen : bool
var text: String

@warning_ignore("shadowed_variable")
func _init(
	type : String,
	seen : bool,
	text : String,
):
	self.type = type
	self.seen = seen 
	self.text = text


@warning_ignore("shadowed_global_identifier")
func _to_string() -> String:
	return "[Mutation] %s | hidden: %s | text: %s " % [
		type,
		seen,
		text
	]
