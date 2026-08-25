extends Node

class_name AdminRandomMutationEvent

var turn: int #
var danger_level: int #
var wait_time: float  #
var wait_time_min: float  #
var wait_time_max: float  #
var mutation_events: Array[RandomMutationEvent]
var finale_choice: String 
var why_none_chose: String


@warning_ignore("shadowed_variable")
func _init(
	turn: int = 0,
	danger_level: int = 0,
	wait_time: int = 0,
	wait_time_min: int = 0,
	wait_time_max: int = 0,
	mutation_events: Array[RandomMutationEvent] = [],
	finale_choice: String = "",
	why_none_chose: String = ""
) -> void:
	self.turn = turn
	self.danger_level = danger_level

	self.wait_time = wait_time
	self.wait_time_min = wait_time_min
	self.wait_time_max = wait_time_max

	self.mutation_events = mutation_events
	self.finale_choice = finale_choice

	self.why_none_chose = why_none_chose


func _to_string() -> String:
	return "[admin random mutation event] | turn: %s | danger level: %s | wait time: %s | wait time min: %s | wait time max: %s | mutation events: %s | finale choice: %s | why none chosen: %s" % [
		turn,
		danger_level,
		wait_time,
		wait_time_min,
		wait_time_max,
		mutation_events,
		finale_choice,
		why_none_chose
	]


static func from_dictionary(data: Dictionary) -> AdminRandomMutationEvent:
	var loaded_mutation_events: Array[RandomMutationEvent] = []

	var raw_mutation_events: Variant = data.get(
		"mutation_events",
		[]
	)

	if raw_mutation_events is Array:
		for raw_event: Variant in raw_mutation_events:
			if raw_event is not Dictionary:
				continue

			loaded_mutation_events.append(
				RandomMutationEvent.from_dictionary(raw_event)
			)

	return AdminRandomMutationEvent.new(
		int(data.get("turn", 0)),
		int(data.get("danger_level", 0)),
		int(data.get("wait_time", 0)),
		int(data.get("wait_time_min", 0)),
		int(data.get("wait_time_max", 0)),
		loaded_mutation_events,
		str(data.get("finale_choice", "")),
		str(data.get("why_none_chose", ""))
	)


func to_dictionary() -> Dictionary:
	var serialized_mutation_events: Array[Dictionary] = []

	for mutation_event: RandomMutationEvent in mutation_events:
		if mutation_event == null:
			continue

		serialized_mutation_events.append(
			mutation_event.to_dictionary()
		)


	return {
		"turn": turn,
		"danger_level": danger_level,
		"wait_time": wait_time,
		"wait_time_min": wait_time_min,
		"wait_time_max": wait_time_max,
		"mutation_events": serialized_mutation_events,
		"finale_choice": finale_choice,
		"why_none_chose": why_none_chose
	}


func is_default() -> bool:
	return (
		turn == 0
		and danger_level == 0
		and wait_time == 0
		and wait_time_min == 0
		and wait_time_max == 0
		and mutation_events.is_empty()
		and finale_choice == null
		and why_none_chose.is_empty()
	)
