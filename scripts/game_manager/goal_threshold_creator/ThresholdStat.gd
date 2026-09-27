extends RefCounted

class_name ThresholdStat


var size : String
var current_value : float
var max_value : float
var disabled : bool


func _init(
	new_size : String,
	new_max_value : float,
	new_disabled : bool = false
) -> void:
	
	size = new_size
	max_value = new_max_value
	current_value = new_max_value
	disabled = new_disabled


func print_info() -> void:
	print("---- THRESHOLD STAT ----")
	print("Size: ", size)
	print("Current Value: ", current_value)
	print("Max Value: ", max_value)
	print("Disabled: ", disabled)
	print("------------------------")
