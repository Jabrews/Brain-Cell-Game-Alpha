extends Node

@onready var parent_station_detacher : Node3D = $"../.."
@onready var refresh_displays : Node = $"../RefreshDisplays"


func _ready() -> void:
	GLGameManagerBus.connect('process_new_ivs', _handle_process_new_ivs)

func _handle_process_new_ivs() :
	
	if GLWorkstationBus.detacher_enabled == true  : 
		
		if parent_station_detacher.enabled == false : 
			
			parent_station_detacher.enabled = true
			refresh_displays._refresh()
	
	else : 
		
		parent_station_detacher.enabled = false 
		refresh_displays._refresh()
		
