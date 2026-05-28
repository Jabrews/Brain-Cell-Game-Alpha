extends Node

# components
@onready var defect_event_update_timer : Timer = $DefectEventUpdateTimer
@onready var jolt_hidden_stat_interpreter : Node = $JoltHiddenStatInterpreter
@onready var jolt_cell_container : Node = $JoltCellContainer

func _ready() -> void:
	defect_event_update_timer.connect("timeout", _on_defect_event_update_timer_timeout)
	
	# start and set wait time
	defect_event_update_timer.wait_time = IVDefectEventManager.defect_event_update_timer_duration
	
	#print('DEBUG : defect_event_manager does not run so no infection events')
	defect_event_update_timer.start()


func _on_defect_event_update_timer_timeout() -> void:
	
	var no_event_chance = IVDefectEventManager.no_event_chance
	var jolt_cell_container_chance = IVDefectEventManager.jolt_cell_container_chance
	var jolt_hidden_stat_interpreter_chance = IVDefectEventManager.jolt_hidden_stat_interpreter_chance
	
	## offer four ##
	# we increase all clean stats by 10%
	if GLShareholderOfferState.offer_4_active :
		if GLShareholderOfferState.display_stat_offer_active_debug_messages :
			print_debug('offer 4')
		no_event_chance += 15
		jolt_cell_container_chance -= 8
		jolt_hidden_stat_interpreter_chance -= 8
	#############
	
	

	var ran_num = randi_range(1, 100)

	if ran_num <= no_event_chance:
		defect_event_update_timer.wait_time = IVDefectEventManager.defect_event_update_timer_duration
		defect_event_update_timer.start()
		return

	elif ran_num <= no_event_chance + jolt_hidden_stat_interpreter_chance:
		jolt_hidden_stat_interpreter._handle_jolt()

	elif ran_num <= (
		no_event_chance
		+ jolt_hidden_stat_interpreter_chance
		+ jolt_cell_container_chance
	):
		jolt_cell_container._handle_jolt()
	
	# start timer again with correct wait time
	defect_event_update_timer.wait_time = IVDefectEventManager.defect_event_update_timer_duration
	defect_event_update_timer.start()
	
 
