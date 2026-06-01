extends Node

class_name StatConstructor

var stat_type : String
var stat_base_clean_value : float
var stat_cap_status : String
var stat_enabled : bool


@warning_ignore("shadowed_variable")
func _init(
	stat_type : String,
	stat_base_clean_value : float,
	stat_cap_status : String,
	stat_enabled : bool = true
) -> void:

	self.stat_type = stat_type
	self.stat_base_clean_value = stat_base_clean_value
	self.stat_cap_status = stat_cap_status
	self.stat_enabled = stat_enabled


func _to_string() -> String:
	return "[StatConstructor: stat_type=%s, stat_base_clean_value=%s, stat_cap_status=%s, stat_enabled=%s]" % [
		stat_type,
		stat_base_clean_value,
		stat_cap_status,
		stat_enabled
	]
