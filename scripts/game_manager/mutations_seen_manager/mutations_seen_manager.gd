extends Node

func _ready() -> void:
	GLMutationSeenManagerBus.connect('mutation_seen_by_player', _handle_mutation_seen_by_player)

var mutations_seen: Dictionary = {
	"airborne": true,
	"sentient": true,
	"lonley": true,
	"disrupter": true,
	"exsplosive": true,
	"cognisance": true,
	"telekinetic": true,
}

func _find_mutation_seen(mutation_type: String) -> bool:
	return mutations_seen.get(mutation_type, false)

func _handle_mutation_seen_by_player(mutation_name : String) :  
	mutations_seen[mutation_name] = true
	
	
