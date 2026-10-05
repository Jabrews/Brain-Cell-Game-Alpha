extends Node

## components
@onready var defect_event_update_timer: Timer = $DefectEventUpdateTimer

# interpreter event
@onready var defect_interpreter : Node = $DefectInterpreter
@onready var defect_cell_container : Node = $DefectCellContainer


#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed('debug1') : 
		#defect_cell_container.sickness_cell_container._handle()
		

func _ready() -> void:
	defect_event_update_timer.wait_time = IVDefectEventManager.defect_event_trigger_wait_time
	defect_event_update_timer.start()


	defect_event_update_timer.connect('timeout', _handle_defect_event_update_timer_timeout)
	

func _handle_defect_event_update_timer_timeout() :
	defect_event_update_timer.wait_time = IVDefectEventManager.defect_event_trigger_wait_time
	roll_defect_event_chance()


func roll_defect_event_chance() -> void:
	
	var events: Array = [
		{"type": "interpreter", "node": defect_interpreter, "chance": IVDefectEventManager.jolt_interpreter_chance},
		{"type": "cell", "node": defect_cell_container, "chance": IVDefectEventManager.cell_container_event_chance}
	]


	### WEIGHT CHANCE OF INTERPRETER ###
	if IVDefectEventManager.weight_increase_interpreter_jolt_chance:
		
		var amount_remaining: int = 20
		
		for event in events:
			if event["type"] == "interpreter":
				continue
			
			var amount_to_transfer: int = min(
				amount_remaining,
				event["chance"]
			)
			
			event["chance"] -= amount_to_transfer
			amount_remaining -= amount_to_transfer
			
			if amount_remaining <= 0:
				break
		
		for event in events:
			if event["type"] == "interpreter":
				event["chance"] += 20 - amount_remaining
				break
	##################################
	
	### GET FINAL CHANCES ###
	
	
	@warning_ignore("unused_variable")
	var interpreter_chance: int = 0
	@warning_ignore("unused_variable")
	var cell_chance: int = 0
	
	for event in events:
		
		match event["type"]:
			"interpreter":
				interpreter_chance = event["chance"]
			
			"cell":
				cell_chance = event["chance"]
	###########################
	
	
	### NO EVENT ROLL ###
	var chance_to_exit: int = randi_range(0, 100)
	
	if chance_to_exit <= IVDefectEventManager.no_event_chance:
		
		return

	
	
	# Keep rolling until one event wins.
	while events.size() > 0:
		
		# Pick a random event to roll next.
		var index: int = randi_range(0, events.size() - 1)
		var event = events[index]
		
		# Roll this event.
		var roll: int = randi_range(0, 100)
		
		if roll < event["chance"]:
			event["node"]._initate_defect_event()
			return
		
		# It failed, so remove it from this round
		# and try another event.
		events.remove_at(index)


	
