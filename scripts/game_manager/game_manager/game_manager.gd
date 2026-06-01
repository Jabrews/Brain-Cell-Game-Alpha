extends Node

# components
@onready var cell_creator : Node = $CellCreator
@onready var cell_manager : Node = $CellManager


func _ready() : 
	connect_signals()
	GLCellCreatorBus.emit_signal('create_target_cell')
	
##### INIT HELPERS ######

func connect_signals() : 
	GLGameManagerBus.connect('proceed_next_round', initate_next_round)


func initate_next_round() : 
	var curr_round = GLGameManagerBus.current_round
	var max_rounds = GLGameManagerBus.max_rounds
	
	if curr_round == max_rounds :
		push_error('GAME FINISHED')
		get_tree().current_scene.queue_free()
	
	# update round logic
	GLGameManagerBus.current_round += 1
	
	# communicate to all components finale round loop ended 
	# (target_compare_station, prisoner_picker_station, breeding_station)
	GLGameManagerBus.emit_signal('finale_turn_ended_new_round_proceed')
	# delete all prior cells
	GLCellManagerBus.emit_signal('delete_cells_for_next_round')
	# create new cells
	GLCellCreatorBus.emit_signal('create_target_cell')
	



	
