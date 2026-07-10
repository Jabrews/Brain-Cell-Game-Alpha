extends Node

class_name BrainCellStat

var type : String
var enabled : bool
var value : float
var defect : float
var hidden : bool

@warning_ignore("shadowed_variable")
func _init(
	type : String,
	enabled : bool,
	value : float,
	defect : float,
	hidden : bool,
):
	self.type = type
	self.enabled = enabled
	self.value = value
	self.defect = defect
	self.hidden = hidden


func _to_string() -> String:
	return "[Stat] %s | enabled: %s | value: %s | defect: %s | hidden: %s" % [
		type,
		enabled,
		value,
		defect,
		hidden
	]
