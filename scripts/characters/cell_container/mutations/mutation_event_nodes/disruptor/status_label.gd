extends Label3D


@export var blink_interval: float = 0.35

var blink_tween: Tween


func _start_blink() -> void:
	_stop_blink()

	visible = true

	blink_tween = create_tween()
	blink_tween.set_loops()

	blink_tween.tween_interval(blink_interval)

	blink_tween.tween_callback(
		func() -> void:
			visible = false
	)

	blink_tween.tween_interval(blink_interval)

	blink_tween.tween_callback(
		func() -> void:
			visible = true
	)


func _stop_blink() -> void:
	if blink_tween:
		blink_tween.kill()
		blink_tween = null

	visible = true
