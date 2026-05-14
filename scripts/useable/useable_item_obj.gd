extends Node

class_name UseableItemObject 

var item_type: String
var item_has_energy: bool
var item_energy: int

@warning_ignore("shadowed_variable")
func _init(item_type: , item_has_energy: bool, item_energy: int = 0) -> void:
	self.item_type = item_type
	self.item_has_energy = item_has_energy
	self.item_energy = item_energy
