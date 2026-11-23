extends Node

class_name PossibleMutationEventChoice 

var mutation_event : MutationEvent
var cell : BrainCell
var away_from_player : bool 


@warning_ignore("shadowed_variable")
func _init(
	mutation_event : MutationEvent,
	cell : BrainCell,
	away_from_player : bool,
) -> void :
	self.mutation_event = mutation_event
	self.cell = cell
	self.away_from_player = away_from_player

@warning_ignore("shadowed_global_identifier")
func _to_string() -> String:
	return "[possible mutation event choice ] | mutation event : %s | cell : %s | away from player : %s"  % [
		mutation_event,
		cell,
		away_from_player,
	]
