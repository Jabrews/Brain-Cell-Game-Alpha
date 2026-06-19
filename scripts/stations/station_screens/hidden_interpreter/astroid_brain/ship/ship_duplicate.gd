extends CharacterBody2D 

@onready var bullet_scene : PackedScene = preload("res://scenes/stations/station_screens/hidden_interpreter/astroid_brain/ship/bullet.tscn")
@onready var bullet_spawn_point : Node2D = $BulletSpawnPoint
@onready var bullets_parent_node : Node = $BulletParentNode

func _shoot() :
	var bullet_instance: CharacterBody2D = bullet_scene.instantiate()
	
	bullet_instance.global_position = bullet_spawn_point.global_position
	bullet_instance.global_rotation = bullet_spawn_point.global_rotation
	
	bullets_parent_node.add_child(bullet_instance)

func _handle_ship_hit() :
	GLInterpreterGames.emit_signal('child_ship_died', self)
	queue_free()
