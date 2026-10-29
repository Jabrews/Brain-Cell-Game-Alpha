extends Sprite2D

# Tiny lock on each stat display in the prisoner profiler.

var org_pos: Vector2
var sprite_is_shaking: bool = false
var sprite_shake_tween: Tween


func _ready() -> void:
	org_pos = position


func _shake() -> void:
	if sprite_is_shaking:
		return

	sprite_is_shaking = true
	var starting_position: Vector2 = position

	sprite_shake_tween = create_tween()

	var shake_amount: float = 6.0
	var shake_speed: float = 0.04

	for _i: int in range(3):
		sprite_shake_tween.tween_property(
			self,
			"position",
			starting_position + Vector2(shake_amount, 0.0),
			shake_speed
		)
		sprite_shake_tween.tween_property(
			self,
			"position",
			starting_position + Vector2(-shake_amount, 0.0),
			shake_speed
		)

	sprite_shake_tween.tween_property(
		self,
		"position",
		starting_position,
		shake_speed
	)

	sprite_shake_tween.finished.connect(func() -> void:
		position = starting_position
		sprite_is_shaking = false
	)
