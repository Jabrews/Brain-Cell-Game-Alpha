extends RefCounted

class_name ThresholdStat


var size : String
var current_value : float
var max_value : float
var disabled : bool
var finished : bool


func _init(
	new_size : String,
	new_current_value : float, 
	new_max_value : float,
	new_disabled : bool = false,
	new_finished : bool = false,
) -> void:
	
	size = new_size
	current_value = new_current_value
	max_value = new_max_value
	disabled = new_disabled
	finished = new_finished


func print_info() -> void:
	print("---- THRESHOLD STAT ----")
	print("Size: ", size)
	print("Current Value: ", current_value)
	print("Max Value: ", max_value)
	print("Disabled: ", disabled)
	print("Finished", finished)
	print("------------------------")
