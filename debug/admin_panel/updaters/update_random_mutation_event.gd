extends Node

var current_turn: int = 0

func _ready() -> void:
	if not GameAdminPanel.enabled:
		return

	GLGameManagerBus.connect('proceed_next_energy_turn', _handle_next_turn)
	GLMutationEventBus.connect('finished_trigger_event', _handle_finished_trigger_event)
	
	GameAdminPanel.updater_random_mutation_event = AdminRandomMutationEvent.new()
	
	
func _handle_next_turn() : 
	current_turn += 1

func _handle_finished_trigger_event(chosen_mutation_event_name : String = '') -> void:
	
	# update chose field if possible. else leave blank
	for mutation: RandomMutationEvent in GameAdminPanel.updater_random_mutation_event.mutation_events:
		if mutation.mutation_event_name == chosen_mutation_event_name: 
			GameAdminPanel.updater_random_mutation_event.finale_choice = mutation
			
	# update turn
	GameAdminPanel.updater_random_mutation_event.turn = current_turn
	# update danger level
	var danger_level : int = get_danger_level()
	GameAdminPanel.updater_random_mutation_event.danger_level = danger_level
	# apped to array of mutation events
	GameAdminPanel.admin_panel_root.admin_random_mutation_event.append(GameAdminPanel.updater_random_mutation_event)

	# create fresh one 
	var new_admin_random_mutation_event := AdminRandomMutationEvent.new()
	GameAdminPanel.updater_random_mutation_event= new_admin_random_mutation_event 


func get_danger_level()	:
	# 75%–100% = 0
	# 50%–75%  = 1
	# 25%–50%  = 2
	# 0%–25%   = 3

	var energy : int = GLGameManagerBus.curr_energy
	var max_energy: int = GLGameManagerBus.max_energy
	var energy_percent: float = float(energy) / float(max_energy)

	if energy_percent >= 0.75:
		return 0
	elif energy_percent >= 0.50:
		return 1
	elif energy_percent >= 0.25:
		return 2
	else : 
		push_error('danger level not found')
		return 0
	
	
