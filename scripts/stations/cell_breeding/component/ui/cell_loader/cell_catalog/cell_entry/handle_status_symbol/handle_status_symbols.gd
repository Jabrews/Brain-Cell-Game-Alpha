extends Node

# components
var status_symbol_p_s : PackedScene = preload("res://scenes/stations/cell_breeding/ui/cell_loader/cell_catalog/status_symbol.tscn")
@onready var spawn_positions : Array[Control] = [
	$"../StatusSymbols/SpawnPos/Pos1",
	$"../StatusSymbols/SpawnPos/Pos2",
	$"../StatusSymbols/SpawnPos/Pos3",
	$"../StatusSymbols/SpawnPos/Pos4"
]
@onready var parent_node : Control = $"../StatusSymbols/ParentNode"

# component helpers
@onready var detect_status_symbol : Node = $DetectStatusSymbol



func _handle(cell : BrainCell) :
	
	# find valid symbols from cells
	var found_status_symbols : Array[String] =  detect_status_symbol._detect(cell)
	
	# chop at index 5 (no more than 4)
	found_status_symbols = found_status_symbols.slice(0, 4)
	
	var i : int = 0
	
	while i < found_status_symbols.size() :
		
		var status_symbol_instance : Control = status_symbol_p_s.instantiate()
		
		# load correct info on instance
		status_symbol_instance.status = found_status_symbols[i]
		
		parent_node.add_child(status_symbol_instance)
		
		# add to correct pos
		status_symbol_instance.global_position = spawn_positions[i].global_position
		
		
		i += 1
