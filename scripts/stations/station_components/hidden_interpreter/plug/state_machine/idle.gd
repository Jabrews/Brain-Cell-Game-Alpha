extends Node

# components
@onready var parent_plug: RigidBody3D = $"../.."

func state_start() : 
	parent_plug.gravity_scale = 1.0

func state_process(_delta : float) :
	pass
	
	

func state_end() :
	pass
