extends Node

@onready var btn_bg_rects: Array[ColorRect] = [
	$"../ButtonUp/ColorRect",
	$"../ButtonDown/ColorRect"
]

@onready var btn_labels: Array[Label] = [
	$"../ButtonUp/UpLabel",
	$"../ButtonDown/DownLabel"
]

const PRESSED_SCALE: float = 1.1
const PRESS_DURATION: float = 0.08
const RELEASE_DURATION: float = 0.12
const PAUSE_DURATION: float = 0.35
const LIGHTEN_AMOUNT: float = 0.4

var button_tween: Tween
var original_bg_scales: Array[Vector2] = []
var original_bg_modulates: Array[Color] = []
var original_label_scales: Array[Vector2] = []
var original_label_modulates: Array[Color] = []


func _ready() -> void:
	for index: int in range(btn_bg_rects.size()):
		var bg: ColorRect = btn_bg_rects[index]
		var label: Label = btn_labels[index]

		original_bg_scales.append(bg.scale)
		original_bg_modulates.append(bg.modulate)
		original_label_scales.append(label.scale)
		original_label_modulates.append(label.modulate)


func _toggle(toggle_value: bool) -> void:
	_stop_button_animation()
	_reset_buttons()

	if not toggle_value:
		return

	button_tween = create_tween().set_loops()
	button_tween.set_trans(Tween.TRANS_SINE)
	button_tween.set_ease(Tween.EASE_IN_OUT)

	for index: int in range(btn_bg_rects.size()):
		var bg: ColorRect = btn_bg_rects[index]
		var label: Label = btn_labels[index]

		button_tween.tween_property(
			bg,
			"scale",
			original_bg_scales[index] * PRESSED_SCALE,
			PRESS_DURATION
		)
		button_tween.parallel().tween_property(
			bg,
			"modulate",
			original_bg_modulates[index].lightened(LIGHTEN_AMOUNT),
			PRESS_DURATION
		)
		button_tween.parallel().tween_property(
			label,
			"scale",
			original_label_scales[index] * PRESSED_SCALE,
			PRESS_DURATION
		)
		button_tween.parallel().tween_property(
			label,
			"modulate",
			original_label_modulates[index].lightened(LIGHTEN_AMOUNT),
			PRESS_DURATION
		)

		button_tween.tween_property(
			bg,
			"scale",
			original_bg_scales[index],
			RELEASE_DURATION
		)
		button_tween.parallel().tween_property(
			bg,
			"modulate",
			original_bg_modulates[index],
			RELEASE_DURATION
		)
		button_tween.parallel().tween_property(
			label,
			"scale",
			original_label_scales[index],
			RELEASE_DURATION
		)
		button_tween.parallel().tween_property(
			label,
			"modulate",
			original_label_modulates[index],
			RELEASE_DURATION
		)

		button_tween.tween_interval(PAUSE_DURATION)


func _stop_button_animation() -> void:
	if button_tween and button_tween.is_running():
		button_tween.kill()

	button_tween = null


func _reset_buttons() -> void:
	for index: int in range(btn_bg_rects.size()):
		btn_bg_rects[index].scale = original_bg_scales[index]
		btn_bg_rects[index].modulate = original_bg_modulates[index]
		btn_labels[index].scale = original_label_scales[index]
		btn_labels[index].modulate = original_label_modulates[index]
