extends Node


func _get_pos(tube_preload: Node2D, last_tube_preload: Node2D) -> Vector2:
	var spawn_type: String = ["top", "middle", "bottom"].pick_random()

	var current_gap_center: Vector2 = get_gap_center_pos(tube_preload)
	var last_gap_center: Vector2 = get_gap_center_pos(last_tube_preload)

	var x_pos: float = (current_gap_center.x + last_gap_center.x) / 2.0
	var y_pos: float

	match spawn_type:
		"top":
			y_pos = min(current_gap_center.y, last_gap_center.y) - 20.0

		"middle":
			y_pos = (current_gap_center.y + last_gap_center.y) / 2.0

		"bottom":
			y_pos = max(current_gap_center.y, last_gap_center.y) + 20.0

		_:
			y_pos = (current_gap_center.y + last_gap_center.y) / 2.0

	return Vector2(x_pos, y_pos)


func get_gap_center_pos(tube_preload: Node2D) -> Vector2:
	var bottom_tube: StaticBody2D = tube_preload.get_child(0)
	var top_tube: StaticBody2D = tube_preload.get_child(1)

	var bottom_tube_top_y: float = get_tube_top_y(bottom_tube)
	var top_tube_bottom_y: float = get_tube_bottom_y(top_tube)

	var center_y: float = (bottom_tube_top_y + top_tube_bottom_y) / 2.0

	var bottom_collision: CollisionShape2D = bottom_tube.get_node("CollisionShape2D")
	var top_collision: CollisionShape2D = top_tube.get_node("CollisionShape2D")

	var center_x: float = (bottom_collision.global_position.x + top_collision.global_position.x) / 2.0

	return Vector2(center_x, center_y)


func get_tube_top_y(tube: StaticBody2D) -> float:
	var collision: CollisionShape2D = tube.get_node_or_null("CollisionShape2D")

	if not collision:
		push_error(tube.name + " has no CollisionShape2D child.")
		return tube.global_position.y

	var rect_shape := collision.shape as RectangleShape2D

	if not rect_shape:
		push_error(tube.name + "'s collision shape is not a RectangleShape2D.")
		return collision.global_position.y

	var half_height: float = rect_shape.size.y * abs(collision.global_scale.y) / 2.0

	return collision.global_position.y - half_height


func get_tube_bottom_y(tube: StaticBody2D) -> float:
	var collision: CollisionShape2D = tube.get_node_or_null("CollisionShape2D")

	if not collision:
		push_error(tube.name + " has no CollisionShape2D child.")
		return tube.global_position.y

	var rect_shape := collision.shape as RectangleShape2D

	if not rect_shape:
		push_error(tube.name + "'s collision shape is not a RectangleShape2D.")
		return collision.global_position.y

	var half_height: float = rect_shape.size.y * abs(collision.global_scale.y) / 2.0

	return collision.global_position.y + half_height
