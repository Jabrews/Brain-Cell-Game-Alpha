extends Node

class_name StatThreshold 

var stat_type : String
var bar_size : String
var max_stat_value : int
var left_stat_value : int

@warning_ignore("shadowed_variable")
func _init(
	stat_type : String,
	bar_size : String,
	max_stat_value : int,
	left_stat_value : int,
) -> void:
	self.stat_type = stat_type
	self.bar_size = bar_size
	self.max_stat_value = max_stat_value
	self.left_stat_value = left_stat_value
