extends Node

@onready var get_above_tube_pos : Node = $"../GetAboveTubePos"

func _get_pos(tube_preload: Node2D) -> Vector2:
	
	# get y position above tube from both
	# kinda hacky uses helper
	var bottom_tube_top_y: float = get_above_tube_pos._get_pos(tube_preload, 'top').y
	var top_tube_bottom_y: float = get_above_tube_pos._get_pos(tube_preload, 'bottom').y

	# use pos to calculate center y pos
	var center_y_pos: float = (bottom_tube_top_y + top_tube_bottom_y) / 2.0

	# get x pos 
	var tube = tube_preload.get_child(0)
	var collision: CollisionShape2D = tube.get_node("CollisionShape2D")
	var center_x_pos: float = collision.global_position.x - 5.0

	return Vector2(center_x_pos, center_y_pos)
	
	
	
	
	
