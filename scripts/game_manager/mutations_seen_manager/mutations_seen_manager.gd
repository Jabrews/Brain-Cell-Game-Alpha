extends Node

var mutations_seen: Dictionary = {
	"airborne": true,
	"teleportation": false,
	"sentient": true,
	"lonley": true,
	"disrupter": true,
	"exsplosive": true,
	"infectious": false,
	"cognisance": true,
	"telekinetic": true,
	"unstable": false,
}


func _find_mutation_seen(mutation_type: String) -> bool:
	return mutations_seen.get(mutation_type, false)
