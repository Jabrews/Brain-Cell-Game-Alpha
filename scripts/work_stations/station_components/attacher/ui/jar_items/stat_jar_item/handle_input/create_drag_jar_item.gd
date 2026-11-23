extends Node

# components
@onready var parent_drag_node : Node = $"../../../../../../../ParentStatItemDragNode"
@onready var drag_stat_jar_item: PackedScene = preload("res://scenes/work_stations/station_components/attacher/ui/jar_items/stat_jar_item/drag_stat_jar_item.tscn")

var current_drag_jar_item : Control

func _create(designated_jar_item: JarItem): 
	
	if not current_drag_jar_item : 
		current_drag_jar_item = drag_stat_jar_item.instantiate()
		
		parent_drag_node.add_child(current_drag_jar_item)
		
		current_drag_jar_item._load_jar_item(designated_jar_item)
		
func _delete() :
	if current_drag_jar_item: 
		current_drag_jar_item._delete()
		
				
		
		
	
	
	
