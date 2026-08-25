extends Node

@onready var sickness_cell_container : Node = $SicknessCellContainer
@onready var bubble_cell_container : Node = $BubbleCellContainer

func _initate_defect_event(): 
	
	

	
# Events that can currently be rolled.
	var events: Array = [
		{'type' : 'sickness', "node": sickness_cell_container, "chance": IVDefectEventManager.container_sickness_chance},
		{'type' : 'bubble', "node": bubble_cell_container, "chance": IVDefectEventManager.container_bubble_chance}
	]
	# Keep rolling until one event wins.
	while events.size() > 0:
		
		# Pick a random event to roll next.
		var index: int = randi_range(0, events.size() - 1)
		var event = events[index]
		
		# Roll this event.
		var roll: int = randi_range(0, 100)
		
		if roll < event["chance"]:
			event["node"]._handle()
			
			# admin stuff
			if GameAdminPanel.enabled:
				GLDefectEventMangerBus.emit_signal(
					"finished_trigger_event",
					"cell-" + event['type'] + '-' + str(event['chance'])
				)
			
			
			return
		
		# It failed, so remove it from this round
		# and try another event.
		events.remove_at(index)
