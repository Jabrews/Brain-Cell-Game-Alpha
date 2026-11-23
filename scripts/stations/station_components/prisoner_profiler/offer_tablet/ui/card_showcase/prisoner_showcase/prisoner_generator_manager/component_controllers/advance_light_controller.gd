extends Node

@onready var advance_light_sprite: AnimatedSprite2D = \
	$"../../../PrisGenerator/Header/AdvanceLightSprite"

const ANIMATION_NAME: StringName = &"Default"
var placeholder_new_cell_wait_time: float = 3.0


func _ready() -> void:
	_update_frame_count()


func _pause() -> void:
	advance_light_sprite.pause()


func _start() -> void:
	advance_light_sprite.play(ANIMATION_NAME)


func _stop() -> void:
	advance_light_sprite.stop()


func _update_frame_count() -> void:
	var sprite_frames := advance_light_sprite.sprite_frames

	# Duplicate once so this change won't affect other sprites sharing the resource.
	sprite_frames = sprite_frames.duplicate()
	advance_light_sprite.sprite_frames = sprite_frames

	var frame_count: int = sprite_frames.get_frame_count(ANIMATION_NAME)
	sprite_frames.set_animation_speed(
		ANIMATION_NAME,
		float(frame_count) / placeholder_new_cell_wait_time
	)

	advance_light_sprite.animation = ANIMATION_NAME
