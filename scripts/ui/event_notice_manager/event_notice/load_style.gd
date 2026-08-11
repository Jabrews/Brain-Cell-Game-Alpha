extends Node


@onready var bg : TextureRect = $"../bg"
@onready var parent_event_notice : Control = $".."
@onready var header_label : Label = $"../Header"
@onready var body_label : Label =  $"../Body"

func _load(event_notice_type : String) : 
	
	match event_notice_type : 	
		'defect_event' : 
			emergency_scale()
			header_label.material.set_shader_parameter("hologram_enabled", true)			
			header_label.add_theme_color_override("font_color", Color(0.918, 0.0, 0.247))
			body_label.add_theme_color_override("font_color", Color.WHITE)
		'mutation_event'  : 
			emergency_scale()
			header_label.material.set_shader_parameter("hologram_enabled", true)			
			header_label.add_theme_color_override("font_color", Color(0.29, 1.0, 0.503, 1.0))
			body_label.add_theme_color_override("font_color", Color.WHITE)
		'age_warning' : 
			header_label.add_theme_color_override("font_color",Color(0.8, 0.494, 0.588) )
			body_label.add_theme_color_override("font_color", Color.WHITE)
		'default'  : 
			header_label.add_theme_color_override("font_color", Color(1.0, 0.596, 0.29))
			body_label.add_theme_color_override("font_color", Color.WHITE)

func emergency_scale() -> void:
	var original_modulate: Color = bg.modulate

	var scale_tween := create_tween()

	scale_tween.tween_property(
		parent_event_notice,
		"scale",
		Vector2(1.05, 1.05),
		0.15
	)

	scale_tween.tween_property(
		parent_event_notice,
		"scale",
		Vector2.ONE,
		0.15
	)

	var color_tween := create_tween()

	# First bring background to full opacity
	color_tween.tween_property(
		bg,
		"modulate:a",
		1.0,
		0.06
	)

	# Flash white while fully opaque
	color_tween.tween_property(
		bg,
		"modulate",
		Color(2.0, 2.0, 2.0, 1.0),
		0.08
	)

	# Return to original color + original opacity
	color_tween.tween_property(
		bg,
		"modulate",
		original_modulate,
		0.22
	)
