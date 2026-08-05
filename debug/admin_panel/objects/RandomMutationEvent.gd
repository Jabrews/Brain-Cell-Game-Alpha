extends Node

class_name RandomMutationEvent


var parent_cell_name: String
var mutation_event_name: String
var chance: int
var situation_increase_applied: bool
var reasons_why_unlikley: Array[String]


@warning_ignore("shadowed_variable")
func _init(
	parent_cell_name: String = "",
	mutation_event_name: String = "",
	chance: int = 0,
	situation_increase_applied: bool = false,
	reasons_why_unlikley: Array[String] = []
) -> void:
	self.parent_cell_name = parent_cell_name
	self.mutation_event_name = mutation_event_name
	self.chance = chance
	self.situation_increase_applied = situation_increase_applied
	self.reasons_why_unlikley = reasons_why_unlikley


func _to_string() -> String:
	return "[random mutation event] | parent cell: %s | mutation event: %s | chance: %s | situation increase applied: %s | reasons why unlikely: %s" % [
		parent_cell_name,
		mutation_event_name,
		chance,
		situation_increase_applied,
		reasons_why_unlikley
	]


static func from_dictionary(data: Dictionary) -> RandomMutationEvent:
	var loaded_reasons: Array[String] = []
	var raw_reasons: Variant = data.get(
		"reasons_why_unlikley",
		[]
	)

	if raw_reasons is Array:
		for reason: Variant in raw_reasons:
			loaded_reasons.append(str(reason))

	return RandomMutationEvent.new(
		str(data.get("parent_cell_name", "")),
		str(data.get("mutation_event_name", "")),
		int(data.get("chance", 0)),
		bool(data.get("situation_increase_applied", false)),
		loaded_reasons
	)


func to_dictionary() -> Dictionary:
	return {
		"parent_cell_name": parent_cell_name,
		"mutation_event_name": mutation_event_name,
		"chance": chance,
		"situation_increase_applied": situation_increase_applied,
		"reasons_why_unlikley": reasons_why_unlikley
	}


func is_default() -> bool:
	return (
		parent_cell_name.is_empty()
		and mutation_event_name.is_empty()
		and chance == 0
		and not situation_increase_applied
		and reasons_why_unlikley.is_empty()
	)
