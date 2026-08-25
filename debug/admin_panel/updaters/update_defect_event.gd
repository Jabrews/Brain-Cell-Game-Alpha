extends Node

var current_turn: int = 0

func _ready() -> void:
	if not GameAdminPanel.enabled:
		return

	GLGameManagerBus.connect('proceed_next_energy_turn', _handle_next_turn)
	GLDefectEventMangerBus.connect('finished_trigger_event', _handle_finished_trigger_event)
	
	GameAdminPanel.updater_defect_event = AdminDefectEvent.new()
	
	
func _handle_next_turn() : 
	current_turn += 1

func _handle_finished_trigger_event(finale_defect_event_base : String = '') -> void:
	
	# update turn
	GameAdminPanel.updater_defect_event.turn = current_turn
	# update urgency phase
	var urgency_phase : int = get_defect_urgency_phase(IVDefectEventManager.current_defect_urgency_num)
	GameAdminPanel.updater_defect_event.defect_urgency_phase = urgency_phase
	# update finale choice
	GameAdminPanel.updater_defect_event.finale_choice = finale_defect_event_base
	
	# appendto array of mutation events
	GameAdminPanel.admin_panel_root.admin_defect_event.append(GameAdminPanel.updater_defect_event)

	# create fresh one 
	var new_admin_defect_event := AdminDefectEvent.new()
	GameAdminPanel.updater_defect_event = new_admin_defect_event


func get_defect_urgency_phase(defect_urgency_num: int) -> int:
	
	var trashcan_max_capacity: int = IVCellTrashcan.max_capaicty
	
	var urgency_percent: float = (
		float(defect_urgency_num) / float(trashcan_max_capacity)
	)
	
	if urgency_percent >= 1.0:
		return 3
	elif urgency_percent >= 0.5:
		return 2
	else:
		return 1
