extends Node3D

# components
@export var cell_container_parent_node : Node # THIS IS FOR BREDCELLSPAWNER
@onready var cell_container_instance : PackedScene = preload("res://scenes/characters/cell_container/cell_container.tscn")
@onready var spawn_position : Node3D = $SpawnPos


func _ready() -> void:
	#GLCellManagerBus.connect('cell_added_to_collection', _handle_cell_added_to_collection)
	GLCellManagerBus.connect('debug_collected_cells_and_target_create', _handle_debug_collected_cells_and_target_create)
	
	
func _handle_debug_collected_cells_and_target_create(collected_cells : Array) :
	for cell : BrainCell in collected_cells : 
		create_cell_container_instance(cell)

func create_cell_container_instance(cell : BrainCell) :
	var cell_container = cell_container_instance.instantiate()
	cell_container.name = cell.name
	cell_container.designated_brain_cell = cell
	cell_container_parent_node.add_child(cell_container)
	cell_container.global_position = spawn_position.global_position
	
	
	
	
	
