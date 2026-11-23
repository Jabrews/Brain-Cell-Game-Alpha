extends Node3D

# plane mesh final values
var top_pos : Vector3 = Vector3(0.005, 1.775, 0.0)
var bottom_pos : Vector3 = Vector3(0.005, 0.088, 0.0)

#var top_scale : Vector3 = Vector3(0.94, 0.94, 0.94)
var top_scale : Vector3 = Vector3(0.97, 0.97, 0.97)
var bottom_scale : Vector3 = Vector3(0.6, 0.94, 0.58)

# mesh componnet
@onready var blood_plane : MeshInstance3D = $BloodPlane

# TODO DELETE THIS HERE
@onready var audio_manager : Node3D = $"../AudioManager"


func _ready() -> void:
	update_blood_plane(0)

func update_blood_plane(curr_trash_filled : int) -> void:
	
	if curr_trash_filled > IVCellTrashcan.max_capaicty :
		curr_trash_filled = IVCellTrashcan.max_capaicty
	
	if curr_trash_filled == 0 :
		blood_plane.visible = false
	else :
		blood_plane.visible = true 
	
	var max_capacity : int = IVCellTrashcan.max_capaicty
	
	var progress : float = float(curr_trash_filled) / float(max_capacity)
	
	blood_plane.position = bottom_pos.lerp(top_pos, progress)
	blood_plane.scale = bottom_scale.lerp(top_scale, progress)
	
func _reset() :
	update_blood_plane(0)
