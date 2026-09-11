extends Node

# components
@onready var cell_catalog_parent_node : Control  = $"../BreedingUI/CellLoader/CellCatalog/CenterContainer/ScrollContainer/GridContainerLeft"
@onready var cell_entry_p_s : PackedScene = preload("res://scenes/stations/cell_breeding/ui/cell_loader/cell_catalog/cell_entry.tscn")


func _display() :
	var collected_cells : Array[BrainCell] = GLCellManagerBus.collected_cells_refrence
	
	for cell : BrainCell in collected_cells : 	
		var entry_instance : Control = cell_entry_p_s.instantiate()	
		
		cell_catalog_parent_node.add_child(entry_instance)
		
		entry_instance._load_cell(cell)

func _reset():
	for entry : Control in cell_catalog_parent_node.get_children() :
		entry.queue_free()
	
	
