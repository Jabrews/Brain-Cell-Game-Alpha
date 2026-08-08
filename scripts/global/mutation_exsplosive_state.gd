extends Node

signal shake_player_cam_from_exsplode()
signal create_exsplosion_decal(cell_global_posiiton : Vector3)

# 'cell_name' : wait_time
var saved_exsplosive_state : Dictionary = {
	
}

func _ready() -> void:
	GLGameManagerBus.connect('process_next_round', _handle_next_round)
	GLCellManagerBus.connect('cell_deleted', _handle_cell_deleted)

func _handle_next_round() :
	saved_exsplosive_state = {}

func _handle_cell_deleted(cell_name : String) :
	if saved_exsplosive_state.has(cell_name) :
		saved_exsplosive_state.erase(cell_name)
