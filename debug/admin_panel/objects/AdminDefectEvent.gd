extends Node

class_name AdminDefectEvent

# NOTICE
# Right now this only keeps track of base chances. such as cell, interpreter, and none
# its important to understand all bases contain more child events with their own chances

var turn: int = 0
var defect_urgency_phase: int = 1
var wait_time: float = 0.0
var defect_event_base: Array[DefectEventBase] = []
var finale_choice: String = ""


@warning_ignore("shadowed_variable")
func _init(
	turn: int = 0,
	defect_urgency_phase: int = 1,
	wait_time: float = 0.0,
	defect_event_base: Array[DefectEventBase] = [],
	finale_choice: String = ""
) -> void:
	self.turn = turn
	self.defect_urgency_phase = defect_urgency_phase
	self.wait_time = wait_time
	self.defect_event_base = defect_event_base
	self.finale_choice = finale_choice


func _to_string() -> String:
	return "[admin defect event] turn %s | defect urgency phase %s | wait time %s" % [
		turn,
		defect_urgency_phase,
		wait_time
	]


static func from_dictionary(data: Dictionary) -> AdminDefectEvent:
	
	var loaded_defect_events: Array[DefectEventBase] = []
	
	var raw_defect_events: Variant = data.get(
		"defect_event_base",
		[]
	)
	
	if raw_defect_events is Array:
		for raw_event: Variant in raw_defect_events:
			
			if raw_event is not Dictionary:
				continue
			
			loaded_defect_events.append(
				DefectEventBase.from_dictionary(raw_event)
			)
	
	
	return AdminDefectEvent.new(
		int(data.get("turn", 0)),
		int(data.get("defect_urgency_phase", 1)),
		float(data.get("wait_time", 0.0)),
		loaded_defect_events,
		str(data.get("finale_choice", ""))
	)


func to_dictionary() -> Dictionary:
	
	var serialized_defect_events: Array[Dictionary] = []
	
	for defect_event: DefectEventBase in defect_event_base:
		
		if defect_event == null:
			continue
		
		serialized_defect_events.append(
			defect_event.to_dictionary()
		)
	
	
	return {
		"turn": turn,
		"defect_urgency_phase": defect_urgency_phase,
		"wait_time": wait_time,
		"defect_event_base": serialized_defect_events,
		"finale_choice": finale_choice
	}


func is_default() -> bool:
	return (
		turn == 0
		and defect_urgency_phase == 1
		and wait_time == 0.0
		and defect_event_base.is_empty()
		and finale_choice == ""
	)
