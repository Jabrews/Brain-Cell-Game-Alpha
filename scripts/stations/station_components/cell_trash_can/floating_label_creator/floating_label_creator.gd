extends Node

@onready var floating_label_scene: PackedScene = preload("res://scenes/stations/station_components/cell_trash_can/floating_label.tscn")
@onready var spawn_pos: Node3D = $SpawnPos


func _create_label() -> void:
	var floating_label_instance: Node3D = floating_label_scene.instantiate()
	
	add_child(floating_label_instance)
	floating_label_instance.global_position = spawn_pos.global_position
	
	floating_label_instance.start()
