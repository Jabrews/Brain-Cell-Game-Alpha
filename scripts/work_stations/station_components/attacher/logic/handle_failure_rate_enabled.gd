extends Node

# components
@onready var parent_station_attacher : Node3D = $"../.."
@onready var failure_chance_parent : Control = $"../../AttacherUI/StatMainView/FailureChanceView"

func _ready() -> void:
	GLGameManagerBus.connect('process_new_ivs', _handle_process_new_ivs)

func _handle_process_new_ivs() :
	
	parent_station_attacher.failure_rate_enabled = GLWorkstationBus.attacher_failure_enabled
	

	
	
	
		
