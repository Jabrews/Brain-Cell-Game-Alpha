extends Node

@onready var cell_container_p_s : PackedScene = preload("res://scenes/characters/cell_container/cell_container.tscn")
@onready var spawn_pos : Node3D =$SpawnPos
@export var cell_container_parent_node : Node 


func _ready() -> void:
	
	# Cell 1
	var cell_one: BrainCell = BrainCell.new(
		"cell_one",
		[],
		BrainCellStat.new("strength", true, 50, 0, true),
		BrainCellStat.new("intelligence", true, 100, 10, false),
		BrainCellStat.new("community", true, 125, 50, false),
		3,
		false,
		false,
	)
	
	
	# Cell 2
	var cell_two : BrainCell = BrainCell.new(
		"cell_two",
		[],
		BrainCellStat.new("strength", true, 200, 100, true),
		BrainCellStat.new("intelligence", true, 50, 10, false),
		BrainCellStat.new("community", true, 75, 0, false),
		3,
		false,
		false,
	)
	
	
	#var cell_three : BrainCell = BrainCell.new(
		#'cell_three',
		#[],
		#BrainCellStat.new("strength", true, 300, 0, false),
		#BrainCellStat.new("intelligence", true, 300, 0, false),
		#BrainCellStat.new("community", true, 300, 0, false),
		#3,
		#false,
		#false,
		#false
	#)
	
	var cells : Array[BrainCell] = []	
	
	cells.append(cell_one)
	cells.append(cell_two)
	#cells.append(cell_three)
	
	GLCellManagerBus.emit_signal('debug_create_collected_cells', cells)
	
	for cell in cells :
		
		var cell_container = cell_container_p_s.instantiate()

		cell_container.name = cell.name
		cell_container.designated_brain_cell = cell

		cell_container_parent_node.add_child(cell_container)

		cell_container.global_position = spawn_pos.global_position
		
		
		
		


	
	
