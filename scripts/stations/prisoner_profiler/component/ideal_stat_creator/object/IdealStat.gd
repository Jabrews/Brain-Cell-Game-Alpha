extends RefCounted

class_name IdealStat

var stat_type: String
var value: float = 0.0
var lock_max_value: float = 100.0
var enabled: bool = true
var energy_spent: int = 0


func _init(
	p_stat_type: String,
	p_value: float = 0.0,
	p_lock_max_value: float = 100.0,
	p_enabled: bool = true,
	p_energy_spent: int = 0
) -> void:
	stat_type = p_stat_type
	value = p_value
	lock_max_value = p_lock_max_value
	enabled = p_enabled
	energy_spent = p_energy_spent


func _to_string() -> String:
	return (
		"IdealStat(type: %s, value: %s, lock_max_value: %s, "
		+ "enabled: %s, energy_spent: %s)"
	) % [stat_type, value, lock_max_value, enabled, energy_spent]
