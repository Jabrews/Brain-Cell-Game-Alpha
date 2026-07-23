extends Node3D

class_name MutationNode


@onready var parent_cell_container: CharacterBody3D = $"../../.."
@onready var parent_mutation_manager: Node = $"../.."

var designated_mutation_event: MutationEvent
var random_event: bool = false


func _ready() -> void:
	_ready_overide()

func mutation_start() -> void:
	_start()

# Called by SyncActiveMutations when this node should be removed.
func mutation_stop() -> void:
	_stop()


# Called by a random event when it finishes naturally.
func random_event_finished() -> void:
	parent_mutation_manager.cell_random_event_ended(
		designated_mutation_event
	)

# ready
func _ready_overide() :
	pass

# Override these.
func _start() -> void:
	pass


func _stop() -> void:
	pass
