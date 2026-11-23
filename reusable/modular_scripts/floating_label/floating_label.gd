extends Label3D

@export var y_axis_postive_transform : float = 0.6


func _process(_delta: float) -> void:
	global_position = get_parent().global_position + Vector3(0, y_axis_postive_transform, 0)
