extends Node

var mutations_seen: Dictionary = {
	"airborne": true,
	"teleportation": true,
	"sentient": true,
	"lonley": true,
	"disrupter": true,
	"exsplosive": true,
	"infectious": true,
	"cognisance": true,
	"telekinetic": true,
	"unstable": true,
}


func _find_mutation_seen(mutation_type: String) -> bool:
	return mutations_seen.get(mutation_type, false)
