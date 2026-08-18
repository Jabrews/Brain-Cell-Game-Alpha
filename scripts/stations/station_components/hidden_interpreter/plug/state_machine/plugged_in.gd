extends Node

# components
@onready var parent_plug: RigidBody3D = $"../.."

var plug_pos : Vector3
var plug_rotation: Basis


func state_start() : 
	parent_plug.freeze = true

	parent_plug.global_position = plug_pos
	parent_plug.global_basis = plug_rotation
	
	parent_plug._toggle_parent_station_plug_status('in') 

func state_process(_delta : float) :
	pass

func state_end() :
	pass
