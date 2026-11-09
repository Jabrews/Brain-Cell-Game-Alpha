extends Node

# componets
@onready var parent_station_attacher : Node = $"../../.."
@onready var blood_type_view : Control = $"../../../AttacherUI/StatMainView/BloodTypeView"

func _refresh() : 
	
	var loaded_cell : BrainCell = parent_station_attacher._get_loaded_cell()
	
	if loaded_cell : 
		blood_type_view.visible = true
	else : 
		blood_type_view.visible = false 
