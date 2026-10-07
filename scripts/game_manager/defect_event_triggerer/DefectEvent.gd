extends RefCounted
class_name DefectEvent

var defect_event_type: String
var chance_to_choose: float


func _init(
	p_defect_event_type: String,
	p_chance_to_choose: float
) -> void:
	defect_event_type = p_defect_event_type
	chance_to_choose = p_chance_to_choose


func _to_string() -> String:
	return "DefectEvent(type: %s, chance_to_choose: %s)" % [
		defect_event_type,
		chance_to_choose
	]
