extends Node3D

class_name MutationNode


@onready var parent_cell_container: CharacterBody3D = $"../../.."
@onready var parent_mutation_manager: Node = $"../.."

var designated_mutation_event: MutationEvent
var random_event: bool = false
var stop_on_pickup : bool = false


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

func reveal_mutation() :
	
	var mutation_name = designated_mutation_event.mutation_name	
	
	# if not already unhidden. then unhide
	var curr_brain_cell : BrainCell = parent_cell_container.designated_brain_cell
	
	# unhide if possible
	for mutation : BrainCellMutation in curr_brain_cell.mutations :
		if mutation.type == mutation_name : 
			if mutation.hidden : 
				GLCellManagerBus.emit_signal('unhide_cell_mutation', curr_brain_cell, mutation)
			
	# toggle mutation seen true if possible
	GLMutationSeenManagerBus.emit_signal('mutation_seen_by_player', mutation_name)
	

# ready
func _ready_overide() :
	pass

# Override these.
func _start() -> void:
	pass


func _stop() -> void:
	pass
