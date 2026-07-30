extends CharacterBody2D


@export var move_speed: float = 150.0

var apply_motion: bool = false
var starting_position: Vector2
var starting_direction: Vector2 = Vector2(-1.0, 1.0)


func _ready() -> void:
	starting_position = global_position


func _start() -> void:
	visible = true
	apply_motion = true

	global_position = starting_position
	velocity = starting_direction.normalized() * move_speed


func _stop() -> void:
	visible = false
	apply_motion = false
	velocity = Vector2.ZERO


func flip_direction(direction_axis: String) -> void:
	match direction_axis:
		"x":
			velocity.x = -velocity.x

		"y":
			velocity.y = -velocity.y


func _physics_process(_delta: float) -> void:
	if not apply_motion:
		return

	move_and_slide()

	for collision_index: int in range(get_slide_collision_count()):
		var collision: KinematicCollision2D = get_slide_collision(
			collision_index
		)

		var collision_normal: Vector2 = collision.get_normal()

		# Hit a left or right wall.
		if abs(collision_normal.x) > 0.5:
			flip_direction("x")

		# Hit a floor or ceiling.
		if abs(collision_normal.y) > 0.5:
			flip_direction("y")
