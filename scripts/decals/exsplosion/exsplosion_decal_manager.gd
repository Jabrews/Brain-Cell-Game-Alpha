extends Node

@onready var exsplosion_decal_p_s : PackedScene = preload("res://scenes/decals/exsplosion/exsplosion_decal.tscn")


func _ready() -> void:
	# explosive mutation
	GLMutationExsplosiveState.connect('create_exsplosion_decal', _handle_create_exsplosion_decal)
	
	# resetting
	GLGameManagerBus.connect('process_next_round', _handle_next_round)


func _handle_create_exsplosion_decal(cell_glob_pos : Vector3) :
	
	var explosion_decal_instance :	RigidBody3D = exsplosion_decal_p_s.instantiate()
	add_child(explosion_decal_instance)
	explosion_decal_instance.global_position = cell_glob_pos + Vector3(0, 1.0, 0)

func _handle_next_round() : 
	for children : RigidBody3D in get_children() :
		children.queue_free()
