extends Node

# components
@onready var pick_num_left_label : Label = $PickNum


#func _ready() -> void:
	#GLCellManagerBus.connect("prisoner_picked_by_player", _handle_prisoner_picked)
	#GLCellCreatorBus.connect("get_newest_prisoner_cells", _handle_new_batch)
	#GLCellManagerBus.connect("delete_remaining_prisoners", _handle_delete_remaining_prisoners)
#
	#update_pick_display()
#
#
#func _handle_new_batch(_new_prisoners) -> void:
	#IVPrisonerSpawner.curr_picked_pris_per_turn = 0
	#update_pick_display()
#
#
#func _handle_prisoner_picked(_prisoner) -> void:
	#IVPrisonerSpawner.curr_picked_pris_per_turn += 1
	#update_pick_display()
#
#
#func _handle_delete_remaining_prisoners() -> void:
	#print("delete remaining prisoners")
	#pick_num_left_label.text = "0"
#
#
#func update_pick_display() -> void:
	#var picks_left = (
		#IVPrisonerSpawner.max_picked_pris_per_turn
		#- IVPrisonerSpawner.curr_picked_pris_per_turn
	#)
#
	#picks_left = maxi(0, picks_left)
#
	#pick_num_left_label.text = str(picks_left)
