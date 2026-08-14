extends Node

@onready var demand_loaded_parent : Control = $LoadedParent
@onready var demand_unloaded_parent : Control = $UnloadedParent


func _toggle_display(type : String) :
	match type :
		'loaded' : 
			demand_loaded_parent.visible = true
			demand_unloaded_parent.visible = false
		'unloaded' :
			demand_loaded_parent.visible = false 
			demand_unloaded_parent.visible = true 

	
