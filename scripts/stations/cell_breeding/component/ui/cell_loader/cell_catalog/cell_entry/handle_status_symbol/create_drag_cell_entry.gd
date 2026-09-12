extends Node

# components
@onready var parent_node_drag_cell : Node = $"../../../../../../../../DragCellEntryParentNode"
@onready var drag_cell_entry_p_s : PackedScene = preload("res://scenes/stations/cell_breeding/ui/cell_loader/cell_catalog/drag_cell_entry.tscn" )

var current_drag_cell_entry : Control



func _create(cell : BrainCell): 
	
	if not current_drag_cell_entry : 
		current_drag_cell_entry = drag_cell_entry_p_s.instantiate()
		
		parent_node_drag_cell.add_child(current_drag_cell_entry)
		
		current_drag_cell_entry._load_cell(cell)
		
func _delete() :
	if current_drag_cell_entry : 
		current_drag_cell_entry._delete()
		
				
		
		
	
	
	
