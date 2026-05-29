extends Node

# componnets
@onready var cell_container_instance : PackedScene = preload('res://scenes/characters/cell_container/CellContainer.tscn')
@export var cell_container_parent_node : Node 
@onready var spawn_pos_1 : Node3D = $SpawnPos1
@onready var spawn_pos_2 : Node3D = $SpawnPos2

func _ready() -> void:
	await get_tree().process_frame
	
	var target_cell : BrainCell = create_target_cell()
	var new_collected_cells : Array[BrainCell] = create_new_brain_cells()
	
	print('DEBUG : added extra signals and method to manager for debug mode ')
	GLCellManagerBus.emit_signal('debug_collected_cells_and_target_create', new_collected_cells, target_cell)

func create_target_cell() : 
	
	var target_cell = BrainCell.new(
		'torso',
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
		'cell-left-1',
		100,	
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
	
	cell_collection.append(cell_left_1)	
	
	spawn_cells_containers(cell_left_1, spawn_pos_1)	
	
	# group 1 
	var cell_left_2 = BrainCell.new(
		'cell-left-2',
		100,	
		100,
		155,
		1000,
		0,
		0,
		0,
		false,
		false,
		false
	)	
	
	
	cell_collection.append(cell_left_2)	
	
	spawn_cells_containers(cell_left_2, spawn_pos_2)	
	
	return cell_collection
	
func spawn_cells_containers(cell_1 : BrainCell, spawn_pos : Node3D) :
	var cell_1_instance = cell_container_instance.instantiate()	
	cell_1_instance.designated_brain_cell = cell_1	
	cell_container_parent_node.add_child(cell_1_instance)
	cell_1_instance.global_position = spawn_pos.global_position
	
	
	
	
	
