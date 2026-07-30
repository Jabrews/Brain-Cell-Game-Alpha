extends Node

class_name Sentient_Dialogue

var text : String
var mood : String

@warning_ignore("shadowed_variable")
func _init(
	text :  String,
	mood : String,
) -> void:
	self.text = text
	self.mood = mood


func _to_string() -> String:
	@warning_ignore("incompatible_ternary")
	return (
		"text %s | mood: %s") % [
		text,
		mood
	]
