extends Node

# componnets
@onready var cell_container_instance : PackedScene = preload('res://scenes/characters/cell_container/CellContainer.tscn')
@export var cell_container_parent_node : Node 
@onready var spawn_pos_1 : Node3D = $SpawnPos1
@onready var spawn_pos_2 : Node3D = $SpawnPos2
@onready var spawn_pos_3 : Node3D = $SpawnPos3

func _ready() -> void:
	var target_cell : BrainCell = create_target_cell()
	var new_collected_cells : Array[BrainCell] = create_new_brain_cells()
	
	# set on manager
	print('DEBUG : added extra signals and method to manager for debug mode ')
	GLCellManagerBus.emit_signal('debug_collected_cells_and_target_create', new_collected_cells, target_cell)
	
	
	

func create_target_cell() : 
	
	var target_cell = BrainCell.new(
		'target_cell',
		140,	
		120,
		155,
		1000,
		0,
		0,
		0,
		false,
		false,
		false
	)	
	
	return target_cell
	


func create_new_brain_cells() : 
	
	var cell_collection : Array[BrainCell] = []
	
	# group 1 
	var cell_left_1 = BrainCell.new(
		'cell_left_1',
		10,	
		60,
		100,
		3,
		30,
		50,
		70,
		false,
		false,
		false
	)
	var cell_right_1 = BrainCell.new(
		'cell_right_1',
		75,	
		120,
		60,
		3,
		10,
		50,
		45,
		false,
		false,
		false
	)
	
	cell_collection.append(cell_left_1)	
	cell_collection.append(cell_right_1)	
	
	spawn_cells_containers(cell_left_1, cell_right_1, spawn_pos_1)	
	
	# group 12
	var cell_left_2 = BrainCell.new(
		'cell_left_2',
		10,	
		140,
		100,
		3,
		30,
		50,
		70,
		true,
		false,
		true,
	)
	var cell_right_2 = BrainCell.new(
		'cell_right_2',
		75,	
		70,
		60,
		3,
		10,
		50,
		45,
		false,
		false,
		false
	)
	
	cell_collection.append(cell_left_2)	
	cell_collection.append(cell_right_2)	
	
	spawn_cells_containers(cell_left_2, cell_right_2, spawn_pos_2)	
	
	
	# group 12
	var cell_left_3 = BrainCell.new(
		'cell_left_3',
		20,	
		50,
		45,
		3,
		18,
		50,
		30,
		false,
		false,
		false,
	)
	var cell_right_3 = BrainCell.new(
		'cell_right_3',
		45,	
		25,
		50,
		3,
		25,
		10,
		30,
		false,
		false,
		false
	)
	
	cell_collection.append(cell_left_3)	
	cell_collection.append(cell_right_3)	
	
	spawn_cells_containers(cell_left_3, cell_right_3, spawn_pos_3)
	
	
	return cell_collection
	
func spawn_cells_containers(cell_1 : BrainCell, cell_2 : BrainCell, spawn_pos : Node3D) :
	var cell_1_instance = cell_container_instance.instantiate()	
	cell_1_instance.designated_brain_cell = cell_1	
	cell_container_parent_node.add_child(cell_1_instance)
	cell_1_instance.global_position = spawn_pos.global_position
	
	var cell_2_instance = cell_container_instance.instantiate()	
	cell_2_instance.designated_brain_cell = cell_2	
	cell_container_parent_node.add_child(cell_2_instance)
	cell_2_instance.global_position = spawn_pos.global_position
	
	
	
	
	
	
