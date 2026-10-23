extends Node

@onready var turn_camera: Camera3D = $TurnCamera

const STARTING_FOV: float = 80.0
const ENDING_FOV: float = 70.0
const ANIMATION_DURATION: float = 2.6


func _initate() -> bool:
	var half_duration := ANIMATION_DURATION * 0.5

	turn_camera.fov = STARTING_FOV
	turn_camera.current = true

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(turn_camera, "fov", ENDING_FOV, half_duration)
	tween.tween_callback(_proceed_to_next_turn)
	tween.tween_property(turn_camera, "fov", STARTING_FOV, half_duration)

	await tween.finished
	turn_camera.current = false
	return true


func _proceed_to_next_turn() -> void:
	GLGameManagerBus.emit_signal("proceed_next_turn")
	GLPrisonerProfilerComponentsBus.emit_signal('play_sound', 'turn_click')
	
	var active_goal_threshold : ThresholdPiece = GLGoalThresholdManagerBus.active_goal_threshold.get_active_piece()
	if active_goal_threshold.turns_remaining == 0 : 
		GLPrisonerProfilerComponentsBus.emit_signal('play_sound', 'turn_alert')
		
