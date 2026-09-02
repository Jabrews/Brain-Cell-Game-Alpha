extends Node

class_name ThresholdStat 

var stat_type : String
var stat_value : int
var stat_size : String

@warning_ignore("shadowed_variable")
func _init(
	stat_type : String,
	stat_value : int,
	stat_size : String,
) -> void:
	self.stat_type = stat_type
	self.stat_value = stat_value
	self.stat_size = stat_size
