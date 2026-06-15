extends Node

@export var point_goal_scene : PackedScene

func _create_point_goal(tube_preload : Node2D, spawn_pos : Vector2, point_amount : int) :
	var point_goal_instance : Node2D = point_goal_scene.instantiate()
	point_goal_instance.point_amount = point_amount
	tube_preload.add_child(point_goal_instance)
	point_goal_instance.global_position = spawn_pos	
