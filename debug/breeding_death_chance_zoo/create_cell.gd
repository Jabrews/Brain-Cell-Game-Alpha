extends Node


func _ready() -> void:
	
	# Cell 1
	var cell_one: BrainCell = BrainCell.new(
		"cell_one",
		[],
		BrainCellStat.new("strength", true, 100, 0, true),
		BrainCellStat.new("intelligence", true, 100, 0, false),
		BrainCellStat.new("community", true, 100, 0, false),
		3,
		false,
		false,
		false
	)
	
	# Cell 2
	var cell_two: BrainCell = BrainCell.new(
		"cell_two",
		[],
		BrainCellStat.new("strength", true, 50, 0, false),
		BrainCellStat.new("intelligence", true, 50, 0, false),
		BrainCellStat.new("community", false, 50, 0, false),
		3,
		false,
		false,
		false
	)
	
	# Target Cell
	var target_cell: BrainCell = BrainCell.new(
		"target_cell",
		[],
		BrainCellStat.new("strength", true, 75, 0, false),
		BrainCellStat.new("intelligence", true, 75, 0, false),
		BrainCellStat.new("community", true, 75, 0, false),
		1000,
		true,
		false,
		false
	)
	
	# Explicitly create a typed BrainCell array
	var collected_cells: Array[BrainCell] = [
		cell_one,
		cell_two
	]
	
	await get_tree().create_timer(0.2).timeout
	
	GLCellManagerBus.emit_signal(
		"debug_collected_cells_and_target_create",
		collected_cells,
		target_cell
	)
