extends Node

# componnets
@onready var froze_mesh : MeshInstance3D = $"../../FrozenMesh"
@onready var sound_froze_state_end : AudioStreamPlayer3D = $"../../FrozeStateEnd"

func state_start() : 
	froze_mesh.visible = true

func state_process(_delta) : 
	pass


func state_end() : 
	froze_mesh.visible = false 
	sound_froze_state_end.play()
