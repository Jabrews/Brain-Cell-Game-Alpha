extends Node

# components
@onready var elevator_mesh: MeshInstance3D = $"../../../Elevator/Elevator/Elevator"
@onready var elevator_coll_shape: CollisionShape3D = $"../../../Elevator/Elevator/CollisionShape3D"

const ELEVATOR_FINALE_UP_POS: Vector3 = Vector3(-0.001, 0.869, -0.004)
const ELEVATOR_FINALE_DOWN_POS: Vector3 = Vector3(-0.001, -0.931, -0.004)

const ELEVATOR_MOVE_DURATION: float = 1.5

var elevator_busy: bool = false
var elevator_move_tween: Tween

#func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed('debug1') : 
		#_toggle_up(true)
	#if Input.is_action_just_pressed('debug2') : 
		#_toggle_up(false)


func _toggle_up(toggle_value: bool) -> void:
	
	if elevator_busy:
		return
	
	if toggle_value:
		_toggle_up_tween()
	else:
		_toggle_down_tween()


func _toggle_up_tween() -> void:
	elevator_busy = true

	if elevator_move_tween:
		elevator_move_tween.kill()

	elevator_move_tween = create_tween().set_parallel(true)
	elevator_move_tween.set_trans(Tween.TRANS_QUAD)
	elevator_move_tween.set_ease(Tween.EASE_IN_OUT)

	elevator_move_tween.tween_property(
		elevator_mesh, "position",
		ELEVATOR_FINALE_UP_POS, ELEVATOR_MOVE_DURATION
	)
	elevator_move_tween.tween_property(
		elevator_coll_shape, "position",
		ELEVATOR_FINALE_UP_POS, ELEVATOR_MOVE_DURATION
	)

	await elevator_move_tween.finished
	elevator_busy = false


func _toggle_down_tween() -> void:
	elevator_busy = true

	if elevator_move_tween:
		elevator_move_tween.kill()

	elevator_move_tween = create_tween().set_parallel(true)
	elevator_move_tween.set_trans(Tween.TRANS_QUAD)
	elevator_move_tween.set_ease(Tween.EASE_IN_OUT)

	elevator_move_tween.tween_property(
		elevator_mesh, "position",
		ELEVATOR_FINALE_DOWN_POS, ELEVATOR_MOVE_DURATION
	)
	elevator_move_tween.tween_property(
		elevator_coll_shape, "position",
		ELEVATOR_FINALE_DOWN_POS, ELEVATOR_MOVE_DURATION
	)

	await elevator_move_tween.finished
	elevator_busy = false
