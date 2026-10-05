extends Node

@onready var cell_container_p_s : PackedScene = preload("res://scenes/characters/cell_container/cell_container.tscn")
@onready var spawn_pos : Node3D =$SpawnPos
@export var cell_container_parent_node : Node


func _ready() -> void:
	
	
	
	# Cell 1
	var cell_1: BrainCell = BrainCell.new(
		"cell_1",
		[],
		BrainCellStat.new("strength", true, 320, 0, false),
		BrainCellStat.new("intelligence", true, 275, 25, false),
		BrainCellStat.new("community", true, 125, 0, false),
		2,
		false,
		false,
	)
	
	
		# Cell 1
	var cell_2: BrainCell = BrainCell.new(
		"cell_2",
		[],
		BrainCellStat.new("strength", true, 320, 0, false),
		BrainCellStat.new("intelligence", true, 275, 25, false),
		BrainCellStat.new("community", true, 125, 0, false),
		2,
		false,
		false,
	)



	# Cell 1
	var cell_3: BrainCell = BrainCell.new(
		"cell_3",
		[],
		BrainCellStat.new("strength", true, 320, 0, false),
		BrainCellStat.new("intelligence", true, 275, 25, false),
		BrainCellStat.new("community", true, 125, 0, false),
		2,
		false,
		false,
	)


	# Cell 1
	var cell_4 : BrainCell = BrainCell.new(
		"cell_4",
		[],
		BrainCellStat.new("strength", true, 320, 0, false),
		BrainCellStat.new("intelligence", true, 275, 25, false),
		BrainCellStat.new("community", true, 125, 0, false),
		2,
		false,
		false,
	)
	
	

	
	
	#var cell_three : BrainCell = BrainCell.new(
		#'cell_three',
		#[],
		#BrainCellStat.new("strength", true, 1, 1, false),
		#BrainCellStat.new("intelligence", true, 1, 1, false),
		#BrainCellStat.new("community", true, 15, 15, false),
		#1,
		#false,
		#false,
	#)
	
	var cells : Array[BrainCell] = []	
	
	cells.append(cell_1)
	cells.append(cell_2)
	cells.append(cell_3)
	cells.append(cell_4)
	
	GLCellManagerBus.emit_signal('debug_create_collected_cells', cells)
	
	for cell in cells :
		
		var cell_container = cell_container_p_s.instantiate()

		cell_container.name = cell.name
		cell_container.designated_brain_cell = cell

		cell_container_parent_node.add_child(cell_container)

		cell_container.global_position = spawn_pos.global_position
