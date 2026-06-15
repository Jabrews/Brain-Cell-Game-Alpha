extends Node


func _get_pos(tube_preload: Node2D, last_tube_preload: Node2D) -> Vector2:
	var current_gap_center: Vector2 = get_gap_center_pos(tube_preload)
	var last_gap_center: Vector2 = get_gap_center_pos(last_tube_preload)

	# X position between both tube scenes
	var x_pos: float = (current_gap_center.x + last_gap_center.x) / 2.0

	# Extreme Y position: top or bottom of screen
	var y_pos: float = [15, 216.0].pick_random()

	return Vector2(x_pos, y_pos)


func get_gap_center_pos(tube_preload: Node2D) -> Vector2:
	var bottom_tube: StaticBody2D = tube_preload.get_child(0)
	var top_tube: StaticBody2D = tube_preload.get_child(1)

	var bottom_collision: CollisionShape2D = bottom_tube.get_node("CollisionShape2D")
	var top_collision: CollisionShape2D = top_tube.get_node("CollisionShape2D")

	var center_x: float = (
		bottom_collision.global_position.x + top_collision.global_position.x
	) / 2.0

	var center_y: float = (
		bottom_collision.global_position.y + top_collision.global_position.y
	) / 2.0

	return Vector2(center_x, center_y)
