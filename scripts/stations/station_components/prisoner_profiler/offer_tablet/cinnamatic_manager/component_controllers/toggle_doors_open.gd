extends Node

# Components
@onready var left_door_mesh: MeshInstance3D = $"../../../../../OfferTablet/FoldingDoorMeshes/DoorL"
@onready var right_door_mesh: MeshInstance3D = $"../../../../../OfferTablet/FoldingDoorMeshes/DoorR"
@onready var component_controllers: Node = $".."

const LEFT_OPEN_ROTATION_X: float = 165.0
const RIGHT_OPEN_ROTATION_X: float = -165.0
const CLOSE_ROTATION_X: float = 0.0

var door_busy: bool = false
var doors_open: bool = false
var door_tween: Tween


func _toggle(toggle_value: bool) -> void:
	if door_busy or doors_open == toggle_value:
		return

	doors_open = toggle_value
	door_busy = true

	var left_target_x: float = CLOSE_ROTATION_X
	var right_target_x: float = CLOSE_ROTATION_X

	if toggle_value:
		

		
		left_target_x = LEFT_OPEN_ROTATION_X
		right_target_x = RIGHT_OPEN_ROTATION_X
	


	_tween_doors_to(left_target_x, right_target_x)

	await door_tween.finished
	door_busy = false
	
	if not toggle_value : 
		GLPrisonerProfilerComponentsBus.emit_signal('play_sound', 'door_close')		
	else : 
		GLPrisonerProfilerComponentsBus.emit_signal('play_sound', 'door_open')		


func _tween_doors_to(
	left_target_x: float,
	right_target_x: float
) -> void:
	if door_tween:
		door_tween.kill()

	door_tween = create_tween()
	door_tween.set_trans(Tween.TRANS_QUAD)
	door_tween.set_ease(Tween.EASE_IN_OUT)

	door_tween.tween_property(
		left_door_mesh,
		"rotation_degrees:x",
		left_target_x,
		component_controllers.DOOR_OPEN_DURATION
	)

	door_tween.parallel().tween_property(
		right_door_mesh,
		"rotation_degrees:x",
		right_target_x,
		component_controllers.DOOR_OPEN_DURATION
	)
