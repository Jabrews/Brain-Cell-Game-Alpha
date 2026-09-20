extends Node

var blood_type_parent : Control
var no_blood_type_parent : Control



func _display(cell: BrainCell, components: Dictionary) -> void:
	
	blood_type_parent = components['blood_type_parent']
	no_blood_type_parent = components['no_blood_type_parent']
	
	
	if cell : 
		blood_type_parent.visible = true
	
	else : 
		blood_type_parent.visible = false
	
	
