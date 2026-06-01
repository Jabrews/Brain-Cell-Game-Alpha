extends Node

# components
@onready var bottom_points : Array[Node2D] = [
	$"../CleanRangePos/Low",
	$"../CleanRangePos/LowMid",
	$"../CleanRangePos/Middle",
	$"../CleanRangePos/HighMid",
	$"../CleanRangePos/High"
]

# caution components
@onready var caution_bg : ColorRect = $"../Caution/CautionBG"
@onready var caution_sprite : Sprite2D = $"../Caution/CautionSymbol"

# warning components
@onready var warning_bg : ColorRect = $"../Warning/WarningBG"
@onready var warning_sprite : Sprite2D = $"../Warning/WarningSymbol"

# range names
const RANGE_NAMES := [
	"low",
	"low-mid",
	"middle",
	"high-mid",
	"high"
]

# current symbol positions
var caution_left_point_index := 2
var caution_right_point_index := 3

var warning_left_point_index := 3
var warning_right_point_index := 4


func _ready() -> void:
	set_symbol("caution")
	set_symbol("warning")


func set_symbol(symbol_type : String) -> void:

	match symbol_type:

		"caution":
			_set_symbol_visual(
				caution_bg,
				caution_sprite,
				caution_left_point_index,
				caution_right_point_index
			)

		"warning":
			_set_symbol_visual(
				warning_bg,
				warning_sprite,
				warning_left_point_index,
				warning_right_point_index
			)


func _set_symbol_visual(
	bg : ColorRect,
	sprite : Sprite2D,
	left_index : int,
	right_index : int
) -> void:

	var left_point = bottom_points[left_index]
	var right_point = bottom_points[right_index]

	bg.position.x = left_point.position.x
	bg.size.x = right_point.position.x - left_point.position.x

	sprite.position.x = (
		left_point.position.x +
		right_point.position.x
	) / 2.0


func toggle_hide_symbol(symbol_type : String, toggle_value : bool) -> void:

	match symbol_type:

		"caution":
			caution_bg.visible = toggle_value
			caution_sprite.visible = toggle_value

		"warning":
			warning_bg.visible = toggle_value
			warning_sprite.visible = toggle_value


func get_caution_ranges() -> Array[String]:
	return _get_ranges(
		caution_left_point_index,
		caution_right_point_index
	)


func get_warning_ranges() -> Array[String]:
	return _get_ranges(
		warning_left_point_index,
		warning_right_point_index
	)


func _get_ranges(
	left_index : int,
	right_index : int
) -> Array[String]:

	var ranges : Array[String] = []

	for i in range(left_index, right_index + 1):
		ranges.append(RANGE_NAMES[i])

	return ranges
