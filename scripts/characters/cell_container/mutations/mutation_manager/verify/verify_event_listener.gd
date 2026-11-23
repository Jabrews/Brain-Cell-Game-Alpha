extends Node

@onready var event_listener_parent_node : Node3D = $"../EventListenerParentNode"


func _verify(cell_mutations : Array[BrainCellMutation]) : 

	# get each listener node
	for listener : Node3D in event_listener_parent_node.get_children() :
		var designated_mutation_event : MutationEvent = listener.designated_mutation_event 
		# get their mutation event type
		var mutation_event_type : String = designated_mutation_event.mutation_name
		
		# bool for if we found corrispondign one 
		var found_corrisponding_mutation : bool = false			
		
		# look through cells current mutations
		for mutation : BrainCellMutation in cell_mutations : 		
			if mutation.type == mutation_event_type : 
				found_corrisponding_mutation = true
				return
				
		# if we found it so keep it 
		if found_corrisponding_mutation : 
			return
		# else destroy the out of data one
		else : 
			listener.queue_free()	
			
			
			
			
			
			
			
		
		
		
		
		
	
	
