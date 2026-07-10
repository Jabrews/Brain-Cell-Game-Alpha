extends Node

@onready var floor_stain_mesh : MeshInstance3D = $FloorStain

func _grow_blood() :
	
	if not floor_stain_mesh.visible :
		floor_stain_mesh.visible = true
	
	floor_stain_mesh.mesh.radius += 0.4
	
func _reset() :
	floor_stain_mesh.visible = false
	floor_stain_mesh.mesh.radius = 1.2
	
