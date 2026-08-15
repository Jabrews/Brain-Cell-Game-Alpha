extends StaticBody3D

# components
@onready var detect_plug_area : Area3D = $DetectPlugArea
@onready var jolt_particles : GPUParticles3D = $JoltParticles
@onready var plug_pos_node : Node3D = $PluginPos

@export var stat_type : String  = 'strength'

var plug_position : Vector3 

func _ready() -> void:
	detect_plug_area.connect('body_entered', _handle_body_entered)
	detect_plug_area.connect('body_exited', _handle_body_exited)
	
	GLDefectEventMangerBus.connect('event_hidden_stat_interpreter_jolt', _handle_event_hidden_stat_interpreter_jolt)
	
	plug_position = plug_pos_node.global_position



func _handle_body_entered(body : Node3D) :
	if body.is_in_group('interpreter_plug') : 
		pass
		
func _handle_body_exited(body : Node3D) :
	if body.is_in_group('interpreter_plug') : 
		_toggle_jolt(false)		
		

func _handle_event_hidden_stat_interpreter_jolt(interpreters_to_jolt : Array) :
	
	for stat : String in interpreters_to_jolt: 
		if stat == stat_type : 
			_toggle_jolt(true)
	
func _toggle_jolt(toggle_value : bool) :
	
	jolt_particles.emitting = toggle_value
	
	if toggle_value : 	
		pass
	else :
		pass
	
	
