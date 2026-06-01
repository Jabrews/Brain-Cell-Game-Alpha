extends Node

# components
@onready var range_manager : Node = $"../SymbolRangeManager"

# symbols
@onready var caution_sprite : Sprite2D = $"../Caution/CautionSymbol"
@onready var warning_sprite : Sprite2D = $"../Warning/WarningSymbol"

var caution_shake_tween : Tween
var warning_shake_tween : Tween

func _handle_update_shake_symbols(curr_clean_range : String) -> void:

	var caution_ranges = range_manager.get_caution_ranges()
	var warning_ranges = range_manager.get_warning_ranges()

	toggle_shake_symbol(
		curr_clean_range in caution_ranges,
		"caution"
	)

	toggle_shake_symbol(
		curr_clean_range in warning_ranges,
		"warning"
	)


func toggle_shake_symbol(toggle_value : bool, symbol_type : String) -> void:

	var sprite : Sprite2D
	var shake_tween : Tween

	match symbol_type:
		"caution":
			sprite = caution_sprite
			shake_tween = caution_shake_tween

		"warning":
			sprite = warning_sprite
			shake_tween = warning_shake_tween

		_:
			return

	# stop shaking
	if not toggle_value:

		if shake_tween:
			shake_tween.kill()

		sprite.rotation_degrees = 0

		if symbol_type == "caution":
			caution_shake_tween = null
		else:
			warning_shake_tween = null

		return

	# already shaking
	if shake_tween:
		return

	# start shaking
	shake_tween = create_tween()
	shake_tween.set_loops()

	shake_tween.tween_property(
		sprite,
		"rotation_degrees",
		-8,
		0.06
	)

	shake_tween.tween_property(
		sprite,
		"rotation_degrees",
		8,
		0.12
	)

	shake_tween.tween_property(
		sprite,
		"rotation_degrees",
		0,
		0.06
	)

	if symbol_type == "caution":
		caution_shake_tween = shake_tween
	else:
		warning_shake_tween = shake_tween
