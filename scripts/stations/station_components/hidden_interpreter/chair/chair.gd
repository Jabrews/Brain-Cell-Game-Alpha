extends Node

var player_in_chair_area: bool = false
var player_in_chair: bool = false

@onready var fake_player_camera: Camera3D = $FakePlayer/CameraPivot/Camera3D
@onready var fake_player_mesh : MeshInstance3D = $FakePlayer/MeshInstance3D
# for camera 
@export var camera_look_target : Node 
@export var camera_foward_refrence : Node 


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if player_in_chair:
			set_player_in_chair(false)
		elif player_in_chair_area:
			set_player_in_chair(true)


func set_player_in_chair(value: bool) -> void:
	fake_player_mesh.visible = value
	
	player_in_chair = value
	player_in_chair_area = !value

	fake_player_camera.current = value

	GLChairBus.emit_signal("toggle_player_sat_on_interpreter_chair", value, 'test-type')


func _on_detect_player_area_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return

	if player_in_chair:
		return

	player_in_chair_area = true
	GLChairBus.emit_signal("toggle_player_entered_interpreter_chair_area", true)


func _on_detect_player_area_body_exited(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return

	if player_in_chair:
		return

	player_in_chair_area = false
	GLChairBus.emit_signal("toggle_player_entered_interpreter_chair_area", false)
