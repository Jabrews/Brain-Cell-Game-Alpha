extends Node3D

# plane mesh final values
var top_pos : Vector3 = Vector3(0.005, 1.775, 0.0)
var bottom_pos : Vector3 = Vector3(0.005, 0.088, 0.0)

#var top_scale : Vector3 = Vector3(0.94, 0.94, 0.94)
var top_scale : Vector3 = Vector3(0.97, 0.97, 0.97)
var bottom_scale : Vector3 = Vector3(0.6, 0.94, 0.58)

var max_interval : int = 10
var curr_interval : int = 0

# mesh componnet
@onready var blood_plane : MeshInstance3D = $BloodPlane

# TODO DELETE THIS HERE
@onready var audio_manager : Node3D = $"../AudioManager"


func _ready() -> void:
	update_blood_plane()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		increment_interval(1)
		audio_manager._play_cell_added_to_trash()
	
	if Input.is_action_just_pressed("debug2"):
		increment_interval(-1)


func increment_interval(direction_multiplier: int) -> void:
	
	if direction_multiplier == -1 and curr_interval == 0:
		return
	
	if direction_multiplier == 1 and curr_interval == max_interval:
		return
	
	curr_interval += direction_multiplier
	
	update_blood_plane()


func update_blood_plane() -> void:
	
	if curr_interval == 0 :
		blood_plane.visible = false
	else :
		blood_plane.visible = true 
	
	var progress : float = float(curr_interval) / float(max_interval)
	
	blood_plane.position = bottom_pos.lerp(top_pos, progress)
	blood_plane.scale = bottom_scale.lerp(top_scale, progress)


	
	
