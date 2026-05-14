extends Node

# component helpers
@export var name_manager : Node 
@onready var clean_stat_helper : Node = $CleanStatHelper
@onready var defect_stat_helper : Node = $DefectStatHelper


func _ready() -> void:
	connect_signals()
	create_class_refrences()

##### INIT HELPERS #####
func connect_signals() : 
	GLCellBreederBus.connect('player_breeded_cells', _handle_player_breeded_cells)

func create_class_refrences() : 
	pass
########################

func _handle_player_breeded_cells(cell_1 : BrainCell, cell_2 : BrainCell) : 
	
	# [strength, intelligence, community]
	var clean_stat_array = clean_stat_helper.generate_clean_stats(cell_1, cell_2)
	var defect_stat_array = defect_stat_helper.generate_defect_stats(cell_1, cell_2)
	
	var new_name = name_manager.pick_prisoner_names()
	
	var new_cell = BrainCell.new(
		new_name,
		clean_stat_array[0],
		clean_stat_array[1],
		clean_stat_array[2],
		3, #lifespan		
		defect_stat_array[0],
		defect_stat_array[1],
		defect_stat_array[2],
	)
	

	GLCellManagerBus.emit_signal('cell_breeded', cell_1, cell_2, new_cell)
