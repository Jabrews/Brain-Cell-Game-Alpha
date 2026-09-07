extends Node

# how much total stat value decreases per second
const DECREASE_PER_SECOND : int = 10

# components
@onready var estimated_time_parent : Control = $"../EstimatedTime"
@onready var estimated_time_label : Label = $"../EstimatedTime/Label"

var float_tween : Tween
var is_floating : bool = false

var alert_tween : Tween
var is_alert : bool = false

var org_estimated_time_parent_pos : Vector2


func _ready() -> void:
	org_estimated_time_parent_pos = estimated_time_parent.global_position


func _display(
	strength_amount_to_decrease : int,
	intelligence_amount_to_decrease : int,
	community_amount_to_decrease : int
) -> void:
	
	var total_amount_to_decrease : int = (
		strength_amount_to_decrease +
		intelligence_amount_to_decrease +
		community_amount_to_decrease
	)
	
	# amount remaining / amount removed each second
	var estimated_seconds : int = ceili(
		float(total_amount_to_decrease) /
		float(DECREASE_PER_SECOND)
	)
	
	var minutes : int = floori(
		float(estimated_seconds) / 60.0
	)
	
	var seconds : int = estimated_seconds % 60
	
	estimated_time_label.text = "%d-%02d" % [
		minutes,
		seconds
	]
	
	
	# under 30 seconds -> float + alert
	if estimated_seconds < 30:
		_toggle_float_tween(true)
		_toggle_alert_tween(true)
	
	# under 1 minute -> float only
	elif estimated_seconds < 60:
		_toggle_float_tween(true)
		_toggle_alert_tween(false)
	
	# normal
	else:
		_toggle_float_tween(false)
		_toggle_alert_tween(false)


func _toggle_float_tween(toggle_value : bool) -> void:
	
	# already in requested state
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
			estimated_time_parent,
			"global_position:y",
			org_estimated_time_parent_pos.y + 5.0,
			0.5
		)
		
		float_tween.tween_property(
			estimated_time_parent,
			"global_position:y",
			org_estimated_time_parent_pos.y - 5.0,
			1.0
		)
		
		float_tween.tween_property(
			estimated_time_parent,
			"global_position:y",
			org_estimated_time_parent_pos.y,
			0.5
		)
	
	else:
		estimated_time_parent.global_position = org_estimated_time_parent_pos


func _toggle_alert_tween(toggle_value : bool) -> void:
	
	# already in requested state
	if toggle_value == is_alert:
		return
	
	is_alert = toggle_value
	
	if alert_tween:
		alert_tween.kill()
		alert_tween = null
	
	
	if toggle_value:
		
		estimated_time_label.add_theme_color_override(
			"font_color",
			Color.RED
		)
		
		alert_tween = create_tween()
		alert_tween.set_loops()
		
		# grow
		alert_tween.tween_property(
			estimated_time_label,
			"scale",
			Vector2(1.2, 1.2),
			0.5
		)
		
		# normal
		alert_tween.tween_property(
			estimated_time_label,
			"scale",
			Vector2(1.0, 1.0),
			0.3
		)
		
		# shrink
		alert_tween.tween_property(
			estimated_time_label,
			"scale",
			Vector2(0.8, 0.8),
			0.2
		)
		
		# return to normal before looping
		alert_tween.tween_property(
			estimated_time_label,
			"scale",
			Vector2(1.0, 1.0),
			0.3
		)
	
	else:
		
		estimated_time_label.scale = Vector2.ONE
		
		estimated_time_label.add_theme_color_override(
			"font_color",
			Color.WHITE
		)
