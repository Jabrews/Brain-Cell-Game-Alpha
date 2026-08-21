extends Node

class_name AdminBatchMutation


var mutations_available: Array[String] #
var mutations_chosen: Array[String] #
var min_mutations: int #
var max_mutations: int #
var fake_mutations_applied: int
var all_hidden_event_applied: bool #
var all_hidden_event_chance: int #
var skipped: bool #
var why_skipped: String #
var energy_phase: int #
var mutations_picked_by_player: Array[String] #
var weighed_hidden_stats_lower : bool


@warning_ignore("shadowed_variable")
func _init(
	mutations_available: Array[String] = [],
	mutations_chosen: Array[String] = [],
	min_mutations: int = 0,
	max_mutations: int = 0,
	fake_mutations_applied: int = 0,
	all_hidden_event_applied: bool = false,
	all_hidden_event_chance: int = 0,
	skipped: bool = false,
	why_skipped: String = "",
	energy_phase: int = 0,
	mutations_picked_by_player: Array[String] = [],
	weighed_hidden_stats_lower : bool = false
) -> void:
	self.mutations_available = mutations_available
	self.mutations_chosen = mutations_chosen
	self.min_mutations = min_mutations
	self.max_mutations = max_mutations
	self.fake_mutations_applied = fake_mutations_applied
	self.all_hidden_event_applied = all_hidden_event_applied
	self.all_hidden_event_chance = all_hidden_event_chance
	self.skipped = skipped
	self.why_skipped = why_skipped
	self.energy_phase = energy_phase
	self.mutations_picked_by_player = mutations_picked_by_player
	self.weighed_hidden_stats_lower = weighed_hidden_stats_lower


func _to_string() -> String:
	return "[admin batch mutation] | available: %s | chosen: %s | min: %s | max: %s | fake mutations applied: %s | all hidden applied: %s | all hidden chance: %s | skipped: %s | why skipped: %s | energy phase: %s | player picks: %s | weighed hidden stat down %s" % [
		mutations_available,
		mutations_chosen,
		min_mutations,
		max_mutations,
		fake_mutations_applied,
		all_hidden_event_applied,
		all_hidden_event_chance,
		skipped,
		why_skipped,
		energy_phase,
		mutations_picked_by_player,
		weighed_hidden_stats_lower,
	]


static func from_dictionary(data: Dictionary) -> AdminBatchMutation:
	return AdminBatchMutation.new(
		_to_string_array(data.get("mutations_available", [])),
		_to_string_array(data.get("mutations_chosen", [])),
		int(data.get("min_mutations", 0)),
		int(data.get("max_mutations", 0)),
		int(data.get("fake_mutations_applied", 0)),
		bool(data.get("all_hidden_event_applied", false)),
		int(data.get("all_hidden_event_chance", 0)),
		bool(data.get("skipped", false)),
		str(data.get("why_skipped", "")),
		int(data.get("energy_phase", 0)),
		_to_string_array(
			data.get("mutations_picked_by_player", [])
		),
		bool(data.get("weighed_hidden_stats_lower", false))
	)


func to_dictionary() -> Dictionary:
	return {
		"mutations_available": mutations_available,
		"mutations_chosen": mutations_chosen,
		"min_mutations": min_mutations,
		"max_mutations": max_mutations,
		"fake_mutations_applied": fake_mutations_applied,
		"all_hidden_event_applied": all_hidden_event_applied,
		"all_hidden_event_chance": all_hidden_event_chance,
		"skipped": skipped,
		"why_skipped": why_skipped,
		"energy_phase": energy_phase,
		"mutations_picked_by_player": mutations_picked_by_player,
		"weighed_hidden_stats_lower" :  weighed_hidden_stats_lower,
	}


static func _to_string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []

	if value is Array:
		for item: Variant in value:
			result.append(str(item))

	return result

func is_default() -> bool:
	return (
		mutations_available.is_empty()
		and mutations_chosen.is_empty()
		and min_mutations == 0
		and max_mutations == 0
		and fake_mutations_applied == 0
		and not all_hidden_event_applied
		and all_hidden_event_chance == 0
		and not skipped
		and why_skipped.is_empty()
		and energy_phase == 0
		and mutations_picked_by_player.is_empty()
		and weighed_hidden_stats_lower == false
	)
	
