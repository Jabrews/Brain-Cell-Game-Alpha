extends InteractableBtn 

@onready var incremental_value_controller : Node = $"../../GameManager/IncrementalValueController"
@onready var cell_container_instance : PackedScene = preload("res://scenes/characters/cell_container/CellContainer.tscn")
@onready var cell_container_parent_node : Node =$"../../Characters/ContainerParentNode"
@onready var spawn_pos : Node3D = $"../SpawnPos"

func _on_btn_interacted():
	
	# max value should be 160
	incremental_value_controller.change_progression_step(1, 1)
	
	var target_cell : BrainCell = create_target_cell()
	
	var flesh_slug_cell : BrainCell = BrainCell.new(
		'slug-cell',
		0,
		0,
		0,
		3,
		160,
		0,
		0,
	)
	
	var collected_cell_array : Array[BrainCell] = [flesh_slug_cell]
	
	GLCellManagerBus.emit_signal('debug_collected_cells_and_target_create', collected_cell_array, target_cell)
	spawn_cells_containers(flesh_slug_cell)
	
func create_target_cell() :	
	return BrainCell.new(
		'example-target-cell',
		160,
		160,
		160,
		1000,
		0,
		0,
		0,
		
	)
	
func spawn_cells_containers(cell_1 : BrainCell) :
	var cell_1_instance = cell_container_instance.instantiate()	
	cell_1_instance.designated_brain_cell = cell_1	
	cell_container_parent_node.add_child(cell_1_instance)
	cell_1_instance.global_position = spawn_pos.global_position
	cell_1_instance.check_for_cell_dead_on_update()
