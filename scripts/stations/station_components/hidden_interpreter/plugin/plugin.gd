extends StaticBody3D

# components
@onready var detect_plug_area: Area3D = $DetectPlugArea
@onready var jolt_particles: GPUParticles3D = $JoltParticles
@onready var plug_pos_node: Node3D = $PluginPos
# sounds
@onready var s_plugged_in : AudioStreamPlayer3D = $PluggedIn
@onready var s_plugged_out : AudioStreamPlayer3D = $PluggedOut

@export var stat_type: String = "strength"
@export var facing_axis: String = "-z"

var plug_position: Vector3

var plugged : bool = false


func _ready() -> void:
	detect_plug_area.body_entered.connect(_handle_body_entered)
	detect_plug_area.body_exited.connect(_handle_body_exited)

	GLDefectEventMangerBus.connect(
		"event_hidden_stat_interpreter_jolt",
		_handle_event_hidden_stat_interpreter_jolt
	)

	plug_position = plug_pos_node.global_position


func _handle_body_entered(body: Node3D) -> void:
	if body.is_in_group("interpreter_plug"):
		handle_plug_in(body)
		plugged = true


func _handle_body_exited(body: Node3D) -> void:
	if body.is_in_group("interpreter_plug"):
		_toggle_jolt(false)
		s_plugged_out.play()
		plugged = false


func handle_plug_in(plug: RigidBody3D) -> void:
	if plug.stat_type != stat_type:
		return
	
	s_plugged_in.play()

	plug_position = plug_pos_node.global_position

	plug.state_machine.plugged_in_state.plug_pos = plug_position
	plug.state_machine.plugged_in_state.plug_rotation = get_plug_rotation()

	plug.state_machine.switch_state(
		plug.state_machine.State.PLUGGED_IN
	)
	



func get_plug_rotation() -> Basis:
	var direction: Vector3

	match facing_axis:
		"-z":
			direction = Vector3(0, 0, -1)

		"z":
			direction = Vector3(0, 0, 1)

		"-x":
			direction = Vector3(-1, 0, 0)

		"x":
			direction = Vector3(1, 0, 0)

		"-y":
			direction = Vector3(0, -1, 0)

		"y":
			direction = Vector3(0, 1, 0)

		_:
			push_error("Invalid facing axis: ", facing_axis)
			direction = Vector3(0, 0, -1)

	return Basis.looking_at(
		direction,
		Vector3.UP
	)


func _handle_event_hidden_stat_interpreter_jolt(
	interpreters_to_jolt: Array
) -> void:


	if plugged == false : 
		return

	for stat: String in interpreters_to_jolt:
		if stat == stat_type:
			_toggle_jolt(true)


func _toggle_jolt(toggle_value: bool) -> void:
	jolt_particles.emitting = toggle_value
