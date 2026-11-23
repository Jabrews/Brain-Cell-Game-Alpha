extends RigidBody3D

# components
@onready var state_machine : Node = $StateMachine
@onready var parent_hidden_interpreter : Node3D = $".."

var stat_type : String  

# is used if leaving radius of plug
var after_snap_pos : Vector3 
var start_pos_diffrence : Vector3 = Vector3(0,0,1)

func _ready() -> void:
	stat_type = parent_hidden_interpreter.stat_type 
	after_snap_pos = global_position + start_pos_diffrence
	

func _toggle_parent_station_plug_status(status : String) : 
	parent_hidden_interpreter._handle_plug(status)
