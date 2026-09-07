extends Node

# components
@onready var emergency_overlay : Control = $"../EmergencyOverlay"
@onready var emergency_label : Label = $"../EmergencyOverlay/EmergencyParent/Label"
@onready var game_end_increment_timer : Timer = $GameEndIncrement

@export var game_end_wait_time : int = 15

var max_game_end_wait_timer : int

var float_tween : Tween
var is_floating : bool = false

var org_emergency_overlay_pos : Vector2


func _ready() -> void:
	game_end_increment_timer.connect(
		"timeout",
		_handle_game_end_increment_timer_timeout
	)
	
	max_game_end_wait_timer = game_end_wait_time
	org_emergency_overlay_pos = emergency_overlay.global_position


func _display(toggle_value : bool) -> void:
	
	emergency_overlay.visible = toggle_value
	
	if toggle_value:
		
		GLGoalThresholdBus.emit_signal('toggle_threshold_emergent_countdown', true, game_end_wait_time)
		
		emergency_label.text = str(game_end_wait_time)
		
		game_end_increment_timer.start()
		_toggle_float_tween(true)
	
	else:
		
		GLGoalThresholdBus.emit_signal('toggle_threshold_emergent_countdown', false, game_end_wait_time)
		
		game_end_increment_timer.stop()
		
		_toggle_float_tween(false)


func _handle_game_end_increment_timer_timeout() -> void:
	
	game_end_wait_time -= 1
	
	emergency_label.text = str(game_end_wait_time)
	
	GLGoalThresholdBus.emit_signal('toggle_threshold_emergent_countdown', true, game_end_wait_time)
	
	if game_end_wait_time <= 0:
		game_end_increment_timer.stop()
		
		GLPlayerState.player_refrence.queue_free()
		GLGameEndBus.emit_signal('game_ended')


func _toggle_float_tween(toggle_value : bool) -> void:
	
	if toggle_value == is_floating:
		return
	
	is_floating = toggle_value
	
	if float_tween:
		float_tween.kill()
		float_tween = null
	
	
	if toggle_value:
		float_tween = create_tween()
		float_tween.set_loops()
		
		float_tween.tween_property(
			emergency_overlay,
			"global_position:y",
			org_emergency_overlay_pos.y + 5.0,
			0.5
		)
		
		float_tween.tween_property(
			emergency_overlay,
			"global_position:y",
			org_emergency_overlay_pos.y - 5.0,
			1.0
		)
		
		float_tween.tween_property(
			emergency_overlay,
			"global_position:y",
			org_emergency_overlay_pos.y,
			0.5
		)
	
	else:
		emergency_overlay.global_position = org_emergency_overlay_pos
