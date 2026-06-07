extends Node

# components
@onready var range_manager : Node = $"../SymbolRangeManager"
@onready var stat_controller_parent : Node3D = $"../../../../.."

# symbols
@onready var caution_sprite : Sprite2D = $"../Caution/CautionSymbol"
@onready var warning_sprite : Sprite2D = $"../Warning/WarningSymbol"

var active_tween : Tween




func _handle_update_shake_symbols(curr_clean_range : String) -> void:

	var caution_active = (
		curr_clean_range in range_manager.get_caution_ranges()
	)
	var warning_active = (
		curr_clean_range in range_manager.get_warning_ranges()
	)

	# warning takes priority if ranges overlap
	if warning_active:
		_activate_symbol("warning")
	elif caution_active:
		_activate_symbol("caution")
	else:
		_deactivate_symbols()


func _activate_symbol(symbol_type : String) -> void:

	_deactivate_symbols()

	var sprite : Sprite2D

	match symbol_type:
		"caution":
			sprite = caution_sprite

		"warning":
			sprite = warning_sprite

		_:
			return

	stat_controller_parent._toggle_alert_symbol(
		true,
		symbol_type
	)

	active_tween = create_tween()
	active_tween.set_loops()

	active_tween.tween_property(
		sprite,
		"rotation_degrees",
		-8,
		0.06
	)

	active_tween.tween_property(
		sprite,
		"rotation_degrees",
		8,
		0.12
	)

	active_tween.tween_property(
		sprite,
		"rotation_degrees",
		0,
		0.06
	)


func _deactivate_symbols() -> void:

	if active_tween:
		active_tween.kill()
		active_tween = null

	caution_sprite.rotation_degrees = 0
	warning_sprite.rotation_degrees = 0

	stat_controller_parent._toggle_alert_symbol(
		false,
		"caution"
	)

	stat_controller_parent._toggle_alert_symbol(
		false,
		"warning"
	)
