extends RefCounted

class_name IdealStat

var stat_type: String
var value: float = 0.0
var lock_max_value: float = 100.0
var enabled: bool = true
var increments_used : int = 0


func _init(
	p_stat_type: String,
	p_value: float = 0.0,
	p_lock_max_value: float = 100.0,
	p_enabled: bool = true,
	p_increments_used : int = 0
) -> void:
	stat_type = p_stat_type
	value = p_value
	lock_max_value = p_lock_max_value
	enabled = p_enabled
	increments_used = p_increments_used


func _to_string() -> String:
	return (
		"IdealStat(type: %s, value: %s, lock_max_value: %s, "
		+ "enabled: %s, increments used : %s)"
	) % [stat_type, value, lock_max_value, enabled,increments_used ]
