extends Node

var current_turn: int = 0

func _ready() -> void:
	if not GameAdminPanel.enabled:
		return

	GLGameManagerBus.connect('proceed_next_energy_turn', _handle_next_turn)
	
	GLCellManagerBus.connect('prisoner_picked_by_player', _handle_prisoner_picked_by_player)
	
	

func _handle_next_turn() -> void:
	_create_next_turn()


func _create_next_turn() -> void:
	
	# update old
	GameAdminPanel.admin_panel_root.admin_batch_mutation[current_turn] = GameAdminPanel.updater_admin_batch_mutation 
	
	current_turn += 1

	var new_batch_mutation := AdminBatchMutation.new()

	GameAdminPanel.updater_admin_batch_mutation = new_batch_mutation

	# update new
	GameAdminPanel.admin_panel_root.admin_batch_mutation[current_turn] = GameAdminPanel.updater_admin_batch_mutation 

func _handle_prisoner_picked_by_player(new_cell : BrainCell) :
	for mutation : BrainCellMutation in new_cell.mutations :
		GameAdminPanel.updater_admin_batch_mutation.mutations_picked_by_player.append(mutation.type)
		
		
		
		
	
	
	
