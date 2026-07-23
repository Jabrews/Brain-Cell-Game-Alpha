extends Node

# components
@onready var cell_manager : Node = $"../GameManager/CellManager"


func _ready() -> void:
	GLMutationEventBus.connect('trigger_random_mutation_failed', _handle_trigger_random_mutation_failed)
	
func _handle_trigger_random_mutation_failed() :
	print('failed to trigger mutation. likely another idle enabled')

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') :	
		
		#{'cell' : BrainCell, mutation_event : MutationEvent}
		var possible_targets = []
		
		for collected_cell : BrainCell in cell_manager.collected_cells : 
			
			for mutation : BrainCellMutation in collected_cell.mutations : 
				for mutation_event : MutationEvent in mutation.mutation_events :
					if mutation_event.event_type == 'random_event' :
						var target_object = {'cell' : collected_cell, 'mutation_event' : mutation_event}
						possible_targets.append(target_object)							
		
		if len(possible_targets) <= 0 : 
			print('unable to find collected cell with mutation')
			return
		
		
		var random_target = possible_targets.pick_random()
		GLMutationEventBus.emit_signal('attempt_to_trigger_random_mutation_event', random_target['mutation_event'], random_target['cell'])	
	
			
	if Input.is_action_just_pressed('debug2') :	
		pass
