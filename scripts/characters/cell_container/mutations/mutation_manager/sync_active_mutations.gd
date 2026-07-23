extends Node

# Parent component
@onready var mutations_parent_node: Node3D = $"../MutationsParentNode"


# SENTIENT
@onready var constant_sentient_talk_p_s: PackedScene = preload(
	"res://scenes/characters/cell_container/mutations/mutation_event_nodes/sentient/constant_sentient_talk.tscn"
)

# AIRBORNE
@onready var random_airborne_fly_p_s: PackedScene = preload(
	"res://scenes/characters/cell_container/mutations/mutation_event_nodes/airborne/random_airborne_fly.tscn"
)

# DISRUPTER
@onready var random_disrupter_disrupt_p_s: PackedScene = preload(
	"res://scenes/characters/cell_container/mutations/mutation_event_nodes/disruptor/random_disrupter_disrupt.tscn"
)

# LONLEY
@onready var constant_lonley_starvation_p_s: PackedScene = preload(
	"res://scenes/characters/cell_container/mutations/mutation_event_nodes/lonley/constant_lonley_starvation.tscn"
)


func _sync(
	active_mutation_events: Array[MutationEvent]
) -> void:
	var active_event_names: Array[String] = []

	# Start newly active events.
	for mutation_event: MutationEvent in active_mutation_events:
		
		var mutation_event_name: String = mutation_event.event_name
		
		active_event_names.append(mutation_event_name)

		if mutations_parent_node.has_node(mutation_event_name):
			continue

		var mutation_event_node: MutationNode = mutation_event_name_to_node(
			mutation_event_name
		)
		
		# Set properties before starting.
		mutation_event_node.name = mutation_event_name
		mutation_event_node.designated_mutation_event = mutation_event
		mutation_event_node.random_event = (
			mutation_event.event_type == "random"
		)

		mutations_parent_node.add_child(mutation_event_node)

		mutation_event_node.mutation_start()

	# Stop events that are no longer active.
	for mutation_event_node: MutationNode in mutations_parent_node.get_children():
		if mutation_event_node.name in active_event_names:
			continue

		mutation_event_node.mutation_stop()
		mutation_event_node.queue_free()


func mutation_event_name_to_node(
	mutation_event_name: String
) -> MutationNode:
	match mutation_event_name:
		# SENTIENT
		"sentient_talk":
			return (
				constant_sentient_talk_p_s.instantiate()
				as MutationNode
			)

		# AIRBORNE
		"airborne_fly":
			return (
				random_airborne_fly_p_s.instantiate()
				as MutationNode
			)

		# DISRUPTER
		"disrupter_disrupt":
			return (
				random_disrupter_disrupt_p_s.instantiate()
				as MutationNode
			)

		# LONLEY
		"lonley_starvation":
			return (
				constant_lonley_starvation_p_s.instantiate()
				as MutationNode
			)

		_:
			print(
				"Unable to find mutation event name: ",
				mutation_event_name
			)
			return null
