extends RefCounted

class_name PrisonerCardStat

var min_value: float
var max_value: float
var enabled: bool


func _init(
	new_min_value: float = 0.0,
	new_max_value: float = 0.0,
	new_enabled: bool = false
) -> void:
	min_value = new_min_value
	max_value = new_max_value
	enabled = new_enabled


func print_stat() -> void:
	print(
		"Min: ", min_value,
		" | Max: ", max_value,
		" | Enabled: ", enabled
	)
