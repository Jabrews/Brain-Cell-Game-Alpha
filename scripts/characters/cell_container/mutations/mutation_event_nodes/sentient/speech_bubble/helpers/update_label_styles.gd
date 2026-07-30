extends Node

@onready var speech_bubble_label: Label = \
	$"../SpeechBubbleTV/SubViewport/ScreenTextSpeechBubble/VBoxContainer/PanelContainer/Label"


func _update(mood: String) -> void:
	var text_material := speech_bubble_label.material as ShaderMaterial

	if text_material == null:
		push_error("Speech bubble Label requires a ShaderMaterial.")
		return

	# Default state for every new line.
	text_material.set_shader_parameter("shake_enabled", false)

	match mood:
		"normal":
			speech_bubble_label.add_theme_color_override(
				"font_color",
				Color.BLACK
			)

		"mad":
			speech_bubble_label.add_theme_color_override(
				"font_color",
				Color.RED
			)

			text_material.set_shader_parameter(
				"shake_enabled",
				true
			)

		"important":
			speech_bubble_label.add_theme_color_override(
				"font_color",
				Color.CADET_BLUE
			)

		_:
			push_warning("Unknown dialogue mood: " + mood)

			speech_bubble_label.add_theme_color_override(
				"font_color",
				Color.BLACK
			)


func _reset() -> void:
	var text_material := speech_bubble_label.material as ShaderMaterial

	if text_material:
		text_material.set_shader_parameter(
			"shake_enabled",
			false
		)
