extends Node

# components
@onready var parent_station_attacher : Node3D=  $"../../.."
# parent components
@onready var main_stat_parents : Array[Control] = [
	$"../../../AttacherUI/StatMainView/Stats/Strength",
	$"../../../AttacherUI/StatMainView/Stats/Intelligence",
	$"../../../AttacherUI/StatMainView/Stats/Community"
]
@onready var no_cell_loaded_label : Label = $"../../../AttacherUI/StatMainView/Stats/NoCellLoadedLabel"
# stat components


func _refresh() :
	
	var loaded_cell : BrainCell = parent_station_attacher._get_loaded_cell()
	
	# reset parents
	for main_stat_parent in main_stat_parents: 
		main_stat_parent.visible = false
	no_cell_loaded_label.visible = false
	
	# no cell, hide stats
	if not loaded_cell : 	
		no_cell_loaded_label.visible = true
		return
	
	else : 
		
		for main_stat_parent in main_stat_parents: 
			main_stat_parent.visible = true 
			
			# load visuals according to cell and state
			main_stat_parent._display(loaded_cell)
		
		
		
	
	
