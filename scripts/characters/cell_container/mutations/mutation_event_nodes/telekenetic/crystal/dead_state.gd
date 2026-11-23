extends Node

# componentns
@onready var parent_crystal_body : CharacterBody3D = $"../.."
@onready var detect_collision_area : Area3D = $"../../DetectCollisionArea"
@onready var crystal_mesh_instance : MeshInstance3D = $"../../MeshInstance3D"
@onready var dead_particles : GPUParticles3D = $"../../DeadParticles"
@onready var s_break : AudioStreamPlayer3D = $"../../Break"

func state_start() -> void:
	
	detect_collision_area.set_deferred('monitoring', false)
	s_break.play()
	crystal_mesh_instance.visible = false
	parent_crystal_body.velocity = Vector3.ZERO	
	dead_particles.emitting = true
	await dead_particles.finished
	parent_crystal_body.queue_free()
	
func state_process(_delta) -> void:
	pass

func state_end() -> void:
	pass
