
extends AnimatedSprite3D

@onready var pop_lifespan_timer: Timer = $PopLifespanTimer

const SWAY_DISTANCE: float = 0.2
const SWAY_SPEED: float = 0.5

var popping: bool = false
var rise_speed: float = 2.0
var elapsed_time: float = 0.0
var starting_position: Vector3
var sway_offset: float = 0.0


func _ready() -> void:
	visible = false
	pop_lifespan_timer.timeout.connect(_handle_pop_lifespan_timer_timeout)


func initialize_bubble(
	lifetime_wait_time: float,
	bubble_scale: float,
	speed: float
) -> void:
	visible = true
	scale = Vector3.ONE * bubble_scale
	rise_speed = speed
	starting_position = position
	sway_offset = randf_range(0.0, TAU)

	pop_lifespan_timer.wait_time = lifetime_wait_time
	pop_lifespan_timer.start()


func _process(delta: float) -> void:
	if popping:
		return

	elapsed_time += delta

	position.y = starting_position.y + elapsed_time * rise_speed
	position.x = starting_position.x + sin(
		elapsed_time * SWAY_SPEED + sway_offset
	) * SWAY_DISTANCE


func _handle_pop_lifespan_timer_timeout() -> void:
	pop()


func pop() -> void:
	if popping:
		return

	popping = true
	pop_lifespan_timer.stop()

	if sprite_frames != null and sprite_frames.has_animation("Pop"):
		play("Pop")
		await animation_finished

	queue_free()
