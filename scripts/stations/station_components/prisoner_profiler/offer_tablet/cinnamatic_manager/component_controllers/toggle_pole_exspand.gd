extends Node

@onready var main_pole_mesh: MeshInstance3D = \
	$"../../../../../OfferTablet/Poles/MainPole2"
@onready var tablet_pole_body: StaticBody3D = \
	$"../../../../../OfferTablet/Poles/TabletHolderPole"
@onready var component_controllers : Node = $".."

const MAIN_POLE_EXPANDED_POS: Vector3 = Vector3(-1.497, 4.400, 5.084)
const TABLET_POLE_EXPANDED_POS: Vector3 = Vector3(-1.497, 4.400, 5.084)

const MAIN_POLE_REST_POS: Vector3 = Vector3(-1.497, 8.822, 5.084)
const TABLET_POLE_REST_POS: Vector3 = Vector3(-1.497, 8.834, 5.084)

var pole_busy: bool = false
var pole_expanded: bool = false
var pole_tween: Tween


func _toggle(toggle_value: bool) -> void:
	if pole_busy or pole_expanded == toggle_value:
		return

	pole_expanded = toggle_value
	pole_busy = true

	var main_target_pos: Vector3 = MAIN_POLE_REST_POS
	var tablet_target_pos: Vector3 = TABLET_POLE_REST_POS

	if toggle_value:
		main_target_pos = MAIN_POLE_EXPANDED_POS
		tablet_target_pos = TABLET_POLE_EXPANDED_POS
		
		GLPrisonerProfilerComponentsBus.emit_signal('play_sound', 'pole_exspand_start')

	_tween_poles_to(main_target_pos, tablet_target_pos)

	await pole_tween.finished
	pole_busy = false

	GLPrisonerProfilerComponentsBus.emit_signal('play_sound', 'stop_pole_moving')


func _tween_poles_to(
	main_target_pos: Vector3,
	tablet_target_pos: Vector3
) -> void:
	if pole_tween:
		pole_tween.kill()
	
	GLPrisonerProfilerComponentsBus.emit_signal('play_sound', 'start_pole_moving')

	pole_tween = create_tween()
	pole_tween.set_trans(Tween.TRANS_QUAD)
	pole_tween.set_ease(Tween.EASE_IN_OUT)

	pole_tween.tween_property(
		main_pole_mesh,
		"position",
		main_target_pos,
		component_controllers.POLE_EXSPAND_DURATION 
	)

	pole_tween.parallel().tween_property(
		tablet_pole_body,
		"position",
		tablet_target_pos,
		component_controllers.POLE_EXSPAND_DURATION 
	)
