extends Node

class_name DefectEventBase


var event_type: String = ""
var event_chance: int = 0
var increase_event_chance: bool = false
var why_increase: String = ""


@warning_ignore("shadowed_variable")
func _init(
	event_type: String = "",
	event_chance: int = 0,
	increase_event_chance: bool = false,
	why_increase: String = ""
) -> void:
	self.event_type = event_type
	self.event_chance = event_chance
	self.increase_event_chance = increase_event_chance
	self.why_increase = why_increase


func _to_string() -> String:
	return "[defect event] type: %s | chance: %s | increase chance: %s | reason: %s" % [
		event_type,
		event_chance,
		increase_event_chance,
		why_increase
	]


static func from_dictionary(data: Dictionary) -> DefectEventBase:
	return DefectEventBase.new(
		str(data.get("event_type", "")),
		int(data.get("event_chance", 0)),
		bool(data.get("increase_event_chance", false)),
		str(data.get("why_increase", ""))
	)


func to_dictionary() -> Dictionary:
	return {
		"event_type": event_type,
		"event_chance": event_chance,
		"increase_event_chance": increase_event_chance,
		"why_increase": why_increase
	}


func is_default() -> bool:
	return (
		event_type == ""
		and event_chance == 0
		and increase_event_chance == false
		and why_increase == ""
	)
