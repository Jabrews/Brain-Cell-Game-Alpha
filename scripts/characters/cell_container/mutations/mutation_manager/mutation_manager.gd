extends Node


# parent cell container
@onready var cell_container : CharacterBody3D = $".."

# helper components
@onready var sync_active_mutations : Node = $SyncActiveMutations


var active_mutation_events: Array[MutationEvent] = []
var paused_constant_events: Array[MutationEvent] = []

func _ready() -> void:
	GLMutationEventBus.connect('attempt_to_trigger_random_mutation_event', _handle_attempt_to_trigger_random_mutation_event)
	
func _process(delta: float) -> void: 
	if Input.is_action_just_pressed('debug2'):
		
		var designated_brain_cell : BrainCell = cell_container.designated_brain_cell
		
		print('cell name : ', designated_brain_cell.name)	
		for active_mutation_event in active_mutation_events : 
			print('active mutations : ', active_mutation_event.name )
	


# called when cell is initilized/updated
func _constant_cell_mutations_refresh(cell_mutations : Array[BrainCellMutation]) :
	
	# loop through mutations
	for mutation : BrainCellMutation in cell_mutations : 
		# loop through MutationEvents
		for mutation_event : MutationEvent in mutation.mutation_events :
			if mutation_event.event_type == 'constant' :
				active_mutation_events.append(mutation_event)
	
	# SYNC
	sync_active_mutations._sync(active_mutation_events)
	
# called to add a random mutation event
func _handle_attempt_to_trigger_random_mutation_event(mutation_event: MutationEvent, target_brain_cell : BrainCell) :
	
	# make sure correct cell is picked for trigger
	var designated_brain_cell : BrainCell = cell_container.designated_brain_cell
	if designated_brain_cell.name != target_brain_cell.name: 
		# if not return
		return
	
	
	####### CHECK FOR IDLE EVENT #########	
	
	# check for other random event nodes
	var found_random_event: bool = false
	
	for active_event: MutationEvent in active_mutation_events:
		if active_event.event_type == "random_event" :
			found_random_event = true
	
	# if found	
	if found_random_event:
		# let picker know it failed
		GLMutationEventBus.emit_signal('trigger_random_mutation_failed')
		return
	
	###### CHECK FOR PAUSABLE/CONSTANT EVENTS #####
	var pausable_constant_events: Array[MutationEvent] = []
	
	for active_event: MutationEvent in active_mutation_events:
		if active_event.event_type == "constant":
			# add paused event
			pausable_constant_events.append(active_event)
			
			# remove from active pool (will be added back)
			active_mutation_events.erase(active_event)
	# if found
	if len(pausable_constant_events) > 0:
		# set state
		paused_constant_events = pausable_constant_events
	
	#### ADD TO ACTIVE ###	
	active_mutation_events.append(mutation_event)	
	
	# SYNC	
	sync_active_mutations._sync(active_mutation_events)


# called after a random event enmds
func cell_random_event_ended(
	ended_mutation_event: MutationEvent
) -> void:
	for index: int in range(active_mutation_events.size() - 1, -1, -1):
		var mutation_event: MutationEvent = active_mutation_events[index]

		# remove from active
		if mutation_event.name == ended_mutation_event.name:
			active_mutation_events.remove_at(index)

	# get back paused events
	reinstate_paused_events()
	
	# SYNC
	sync_active_mutations._sync(active_mutation_events)

# get back paused events into active
func reinstate_paused_events() -> void:
	active_mutation_events.append_array(paused_constant_events)
	paused_constant_events.clear()
		
