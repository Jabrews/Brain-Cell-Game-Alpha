extends Node3D

@export var time_alive: float = 5.0

@onready var sprite: Sprite3D = $Sprite3D

const FLOAT_DISTANCE: float = 2.0
const FADE_START_PERCENT: float = 0.75


func start() -> void:
	var start_position: Vector3 = global_position
	var end_position: Vector3 = start_position + Vector3(0.0, FLOAT_DISTANCE, 0.0)

	var fade_start_time: float = time_alive * FADE_START_PERCENT
	var fade_duration: float = time_alive - fade_start_time

	var move_tween: Tween = create_tween()
	move_tween.tween_property(self, "global_position", end_position, time_alive)

	var fade_tween: Tween = create_tween()
	fade_tween.tween_interval(fade_start_time)

	if sprite:
		fade_tween.tween_property(sprite, "modulate:a", 0.0, fade_duration)

	fade_tween.tween_callback(queue_free)
