extends Node

@onready var elevator_lid_mesh: MeshInstance3D = $"../../../Elevator/ElevatorLid/ElevatorLid"
@onready var elevator_lid_coll_shape: CollisionShape3D = $"../../../Elevator/ElevatorLid/CollisionShape3D"

const OPEN_FINALE_TRANSFORM: Vector3 = Vector3(0.054, 0.888, 0.999)
const CLOSED_FINALE_TRANSFORM: Vector3 = Vector3(0.977, 0.888, 0.999)
const DOOR_TWEEN_DURATION: float = 1.0

var door_busy: bool = false
var door_tween: Tween
var lid_open: bool = true


func _toggle_open(toggle_value: bool) -> void:
	if door_busy or lid_open == toggle_value:
		return

	lid_open = toggle_value

	if toggle_value:
		_toggle_open_door_tween()
	else:
		_toggle_close_door_tween()


func _toggle_open_door_tween() -> void:
	door_busy = true
	elevator_lid_coll_shape.disabled = true

	GLGoalThresholdManagerBus.emit_signal("play_sound", "lid_open")
	_tween_lid_to(OPEN_FINALE_TRANSFORM)

	await door_tween.finished
	door_busy = false


func _toggle_close_door_tween() -> void:
	door_busy = true
	elevator_lid_coll_shape.disabled = true

	GLGoalThresholdManagerBus.emit_signal("play_sound", "lid_close")
	_tween_lid_to(CLOSED_FINALE_TRANSFORM)
	
	elevator_lid_coll_shape.disabled = false

	await door_tween.finished

	door_busy = false


func _tween_lid_to(target_scale: Vector3) -> void:
	if door_tween:
		door_tween.kill()

	door_tween = create_tween()
	door_tween.set_trans(Tween.TRANS_QUAD)
	door_tween.set_ease(Tween.EASE_IN_OUT)

	door_tween.tween_property(
		elevator_lid_mesh,
		"scale",
		target_scale,
		DOOR_TWEEN_DURATION
	)

	door_tween.parallel().tween_property(
		elevator_lid_coll_shape,
		"scale",
		target_scale,
		DOOR_TWEEN_DURATION
	)
