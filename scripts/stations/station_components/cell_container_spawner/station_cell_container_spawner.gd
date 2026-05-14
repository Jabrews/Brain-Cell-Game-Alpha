extends Node3D

# components
@export var cell_container_parent_node : Node # THIS IS FOR BREDCELLSPAWNER
@onready var cell_container_instance : PackedScene = preload("res://scenes/characters/cell_container/CellContainer.tscn")
@onready var spawn_position : Node3D = $SpawnPos


func _ready() -> void:
	GLCellManagerBus.connect('cell_added_to_collection', _handle_cell_added_to_collection)

func _handle_cell_added_to_collection(new_collected_cell : BrainCell): 
	create_cell_container_instance(new_collected_cell)	

func create_cell_container_instance(cell : BrainCell) :
	var cell_container = cell_container_instance.instantiate()
	cell_container.name = cell.name
	cell_container.designated_brain_cell = cell
	cell_container_parent_node.add_child(cell_container)
	cell_container.global_position = spawn_position.global_position
	
	
	
	
	
