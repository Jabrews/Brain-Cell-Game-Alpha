
extends Node

# component packed scenes
@onready var stat_jar_item_p_s: PackedScene = preload("res://scenes/work_stations/station_components/attacher/ui/jar_items/stat_jar_item/stat_jar_item.tscn")

# components
@onready var parent_grid_container: GridContainer = $"../../../AttacherUI/JarItemCatalog/CenterContainer/ScrollContainer/GridContainerLeft"
@onready var no_jar_items_found_label : Label = $"../../../AttacherUI/JarItemCatalog/NoJarItemsFoundLabel"

# helper components
@onready var sort_used_jar_items: Node = $SortUsedJarItems


func _refresh() -> void:

	# clear catalog
	for jar_item: Control in parent_grid_container.get_children():
		jar_item.queue_free()

	# sort jar items
	var sorted_items: Dictionary = sort_used_jar_items._find()

	var used_jar_items: Array[JarItem] = sorted_items["used"]
	var unused_jar_items: Array[JarItem] = sorted_items["unused"]
	

	
	# deal with no items found label
	if len(used_jar_items) == 0 and len(unused_jar_items) == 0 : 	
		no_jar_items_found_label.visible = true 
		
		
		return
		
	else : 
		no_jar_items_found_label.visible = false 
	

	# maximum item error catch
	if used_jar_items.size() + unused_jar_items.size() > 4:
		push_error("Too many jar items found")
		return

	# create catalog items
	for jar_item: JarItem in GLJarComponentBus.jar_items:

		var jar_item_instance: Control

		match jar_item.item_type:
			"stat":
				jar_item_instance = stat_jar_item_p_s.instantiate()

			_:
				push_error("Unable to create catalog jar item of type: ", jar_item.item_type)
				continue

		parent_grid_container.add_child(jar_item_instance)
		jar_item_instance._start(jar_item)

		# mark used items
		if jar_item in used_jar_items:
			jar_item_instance._item_used()
			
			
