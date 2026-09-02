extends Node

# components
@onready var cell_creator : Node = $CellCreator
@onready var cell_manager : Node = $CellManager
@onready var goal_threshold_manager : Node = $GoalThresholdManager
@onready var incremental_value_controller : Node = $IncrementalValueController


func _ready() : 
	connect_signals()
	
	GLGameManagerBus.current_round = 1
	incremental_value_controller.change_progression_step(GLGameManagerBus.current_round, GLGameManagerBus.curr_energy)
	goal_threshold_manager._create_goal()
	
##### INIT HELPERS ######

func connect_signals() : 
	GLGameManagerBus.connect('proceed_next_round', initate_next_round)


func initate_next_round() : 
	var curr_round = GLGameManagerBus.current_round
	var max_rounds = GLGameManagerBus.max_rounds
	
	if curr_round >= max_rounds :
		push_error('GAME FINISHED')
		get_tree().current_scene.queue_free()
	
	# update round logic
	GLGameManagerBus.current_round += 1
	incremental_value_controller.change_progression_step(GLGameManagerBus.current_round, GLGameManagerBus.curr_energy)
	
	# delete all prior cells
	GLCellManagerBus.emit_signal('delete_cells_for_next_round')
	



	
