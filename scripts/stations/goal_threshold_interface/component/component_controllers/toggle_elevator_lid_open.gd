extends Node

# components
@onready var elevator_lid_mesh: MeshInstance3D = $"../../../Elevator/ElevatorLid/ElevatorLid"
@onready var elevator_lid_coll_shape: CollisionShape3D = $"../../../Elevator/ElevatorLid/CollisionShape3D"

const OPEN_FINALE_TRANSFORM: Vector3 = Vector3(0.054, 0.888, 0.999)
const CLOSED_FINALE_TRANSFORM: Vector3 = Vector3(0.977, 0.888, 0.999)

const DOOR_TWEEN_DURATION: float = 1.0

var door_busy: bool = false
var door_tween: Tween

var lid_open : bool = true 

#func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed('debug1') : 
		#_toggle_open(true)
	#if Input.is_action_just_pressed('debug2') : 
		#_toggle_open(false)


func _toggle_open(toggle_value: bool) -> void:
	
	if door_busy:
		return
	
	if lid_open == toggle_value : 
		return
	
	if toggle_value:
		_toggle_open_door_tween()
		elevator_lid_coll_shape.disabled = true 
	else:
		_toggle_close_door_tween()
		elevator_lid_coll_shape.disabled = false 
		
	lid_open = toggle_value


func _toggle_open_door_tween() -> void:
	
	door_busy = true
	
	# disable collision when opening
	
	if door_tween:
		door_tween.kill()
	
	door_tween = create_tween()
	
	door_tween.set_trans(Tween.TRANS_QUAD)
	door_tween.set_ease(Tween.EASE_IN_OUT)
	
	GLGoalThresholdManagerBus.emit_signal('play_sound', 'lid_open')
	
	door_tween.tween_property(
		elevator_lid_mesh,
		"scale",
		OPEN_FINALE_TRANSFORM,
		DOOR_TWEEN_DURATION
	)
	
	await door_tween.finished
	
	door_busy = false


func _toggle_close_door_tween() -> void:
	
	door_busy = true
	
	if door_tween:
		door_tween.kill()
	
	door_tween = create_tween()
	
	door_tween.set_trans(Tween.TRANS_QUAD)
	door_tween.set_ease(Tween.EASE_IN_OUT)
	
	GLGoalThresholdManagerBus.emit_signal('play_sound', 'lid_close')
	
	door_tween.tween_property(
		elevator_lid_mesh,
		"scale",
		CLOSED_FINALE_TRANSFORM,
		DOOR_TWEEN_DURATION
	)
	
	await door_tween.finished
	
	# enable collision after fully closed
	
	door_busy = false
