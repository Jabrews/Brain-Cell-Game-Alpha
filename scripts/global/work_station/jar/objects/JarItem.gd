extends RefCounted

class_name JarItem

var item_type : String

func _init(
	new_item_type : String
) -> void:
	item_type = new_item_type

func print_jar_item() : 
	print('Type : ', item_type)
	
	
