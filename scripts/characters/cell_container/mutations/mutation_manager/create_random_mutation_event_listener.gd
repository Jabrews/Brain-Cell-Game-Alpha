extends Node3D

@onready var airborne_random_event_listner_p_s : PackedScene = preload("res://scenes/characters/cell_container/mutations/mutation_random_event_listeners/airborne/airborne_random_event_listener.tscn" )
@onready var disruptor_random_event_listner_p_s : PackedScene = preload("res://scenes/characters/cell_container/mutations/mutation_random_event_listeners/disruptor/disruptor_random_event_listener.tscn")

func _create(mutation_event : MutationEvent) :
	
	# only random events get these
	if not mutation_event.event_type == 'random_event' :
		return
	
	var already_exist : bool = verify_doesnt_exist(mutation_event.event_name)
	if already_exist : 
		return
	
	# dont really need to specify specifc event ones yet.only one mutation event per cell
	var listener_scene : PackedScene = get_packed_scene(mutation_event.mutation_name)
	
	if not  listener_scene: 
		return
	
	var listener_instance : Node3D = listener_scene.instantiate()
	
	listener_instance.designated_mutation_event = mutation_event
	add_child(listener_instance)
	
func get_packed_scene(mutation_type : String) -> PackedScene :
	match mutation_type : 	
		'airborne' :
			return airborne_random_event_listner_p_s
		'disrupter' :
			return disruptor_random_event_listner_p_s
		_ : 
			return null


func verify_doesnt_exist(event_name: String) -> bool : 
	for listener : Node3D in get_children() :
		var designated_mutation_event : MutationEvent = listener.designated_mutation_event 
		if designated_mutation_event.event_name == event_name :
			return true
	
	return false
	
	
	

	
	
	
	
