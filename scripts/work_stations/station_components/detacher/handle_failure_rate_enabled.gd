extends Node

# components
@onready var parent_station_detacher : Node3D = $"../.."
@onready var failure_chance_tv_parent : Node3D = $"../../FailureChanceTV"

func _ready() -> void:
	GLGameManagerBus.connect('process_new_ivs', _handle_process_new_ivs)

func _handle_process_new_ivs() :
	
	parent_station_detacher.failure_rate_enabled = GLWorkstationBus.detacher_failure_enabled 

	if not GLWorkstationBus.detacher_failure_enabled : 
		failure_chance_tv_parent.visible = false
	
	else : 
		failure_chance_tv_parent.visible = true 
	

	
	
	
		
