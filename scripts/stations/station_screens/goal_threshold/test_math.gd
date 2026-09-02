extends Node

@onready var strength_bar : Sprite2D = $"../Stats/Strength/StrengthBar"
@onready var increment_down_timer : Timer = $IncrementDownTimer

@export var decrease_amount : int = 200

var max_strength_value : float
var decrease_to_value : float


func _ready() -> void:
	increment_down_timer.connect("timeout", _handle_increment_down_timer)


func _start(new_max_strength_value : float) -> void:
	max_strength_value = new_max_strength_value
	
	var current_strength : float = GLGoalThresholdBus.active_goal_threshold.strength.stat_value
	
	decrease_to_value = current_strength - decrease_amount
	
	increment_down_timer.start()


func _handle_increment_down_timer() -> void:
	GLGoalThresholdBus.active_goal_threshold.strength.stat_value -= 1
	
	var current_strength : float = GLGoalThresholdBus.active_goal_threshold.strength.stat_value
	
	# red current value
	var red_shader_value : float = current_strength / max_strength_value
	
	strength_bar.material.set_shader_parameter(
		"red_value",
		red_shader_value
	)
	
	# yellow = remaining distance to target
	var remaining_decrease : float = current_strength - decrease_to_value
	
	var yellow_shader_value : float = remaining_decrease / max_strength_value
	
	strength_bar.material.set_shader_parameter(
		"yellow_value",
		yellow_shader_value
	)
	
	if current_strength <= decrease_to_value:
		strength_bar.material.set_shader_parameter(
			"yellow_value",
			0.0
		)
		
		increment_down_timer.stop()
