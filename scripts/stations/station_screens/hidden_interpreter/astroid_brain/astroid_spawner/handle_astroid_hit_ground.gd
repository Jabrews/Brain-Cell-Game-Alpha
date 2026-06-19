extends Node

# componnets
@onready var exsplosion_scene : PackedScene = preload("res://scenes/stations/station_screens/hidden_interpreter/astroid_brain/astroid/exsplosion.tscn")

func _handle(global_pos : Vector2, max_health : int) :
	var exsplosion_instance : Node2D= exsplosion_scene.instantiate()
	exsplosion_instance.astroid_max_health = max_health
	exsplosion_instance.global_position = global_pos	
	get_parent().get_parent().call_deferred("add_child", exsplosion_instance)		
	
	
	
	
