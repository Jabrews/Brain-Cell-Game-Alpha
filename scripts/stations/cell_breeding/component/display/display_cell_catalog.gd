extends Node

# components
@onready var cell_catalog_parent_node : Control  = $"../BreedingUI/CellLoader/CellCatalog/CenterContainer/ScrollContainer/GridContainerLeft"
@onready var cell_entry_p_s : PackedScene = preload("res://scenes/stations/cell_breeding/ui/cell_loader/cell_catalog/cell_entry.tscn")


func _display() :
	var collected_cells : Array[BrainCell] = GLCellManagerBus.collected_cells_refrence.duplicate()
	
	collected_cells = sort_cells(collected_cells)
	
	for cell : BrainCell in collected_cells : 	
		var entry_instance : Control = cell_entry_p_s.instantiate()	
		
		cell_catalog_parent_node.add_child(entry_instance)
		
		entry_instance._load_cell(cell)

func _reset():
	for entry : Control in cell_catalog_parent_node.get_children() :
		entry.queue_free()
	
func sort_cells(collected_cells: Array[BrainCell]) -> Array[BrainCell]:
	
	collected_cells.sort_custom(func(a: BrainCell, b: BrainCell) -> bool:
		
		# unavailable cells always go to the bottom
		if a.breeder_unavaible != b.breeder_unavaible:
			return not a.breeder_unavaible
		
		
		var a_total: float = 0.0
		var b_total: float = 0.0
		
		
		# cell A
		if a.strength.enabled and not a.strength.hidden:
			a_total += a.strength.value
		
		if a.intelligence.enabled and not a.intelligence.hidden:
			a_total += a.intelligence.value
		
		if a.community.enabled and not a.community.hidden:
			a_total += a.community.value
		
		
		# cell B
		if b.strength.enabled and not b.strength.hidden:
			b_total += b.strength.value
		
		if b.intelligence.enabled and not b.intelligence.hidden:
			b_total += b.intelligence.value
		
		if b.community.enabled and not b.community.hidden:
			b_total += b.community.value
		
		
		return a_total > b_total
	)
	
	return collected_cells


	
