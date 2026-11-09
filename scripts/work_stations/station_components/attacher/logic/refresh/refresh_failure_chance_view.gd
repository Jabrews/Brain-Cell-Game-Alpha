extends Node

# componets
@onready var parent_station_attacher : Node = $"../../.."
@onready var failure_chance_view : Control = $"../../../AttacherUI/StatMainView/FailureChanceView"

func _refresh() :
	
	var loaded_cell : BrainCell = parent_station_attacher._get_loaded_cell()
	
	if loaded_cell : 
		failure_chance_view.visible = true
	else : 
		failure_chance_view.visible = false 
