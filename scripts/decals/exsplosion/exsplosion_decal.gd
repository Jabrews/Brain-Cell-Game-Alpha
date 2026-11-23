extends RigidBody3D

@onready var mesh : MeshInstance3D = $Mesh

func _ready() -> void:
	
	mesh.visible = false
	
	gravity_scale = 7.0

	# Keep the mark flat.
	axis_lock_angular_x = true
	axis_lock_angular_y = true
	axis_lock_angular_z = true

	can_sleep = true
	
	await get_tree().create_timer(0.35).timeout 
	
	mesh.visible = true
	
	
	
