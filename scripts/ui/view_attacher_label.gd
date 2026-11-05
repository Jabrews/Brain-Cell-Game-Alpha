extends Control

func _ready() -> void:
	GLAttacherComponentBus.connect('toggle_show_view_attacher_label', _handle_toggle_show_view_attacher_label)

func _handle_toggle_show_view_attacher_label(toggle_value : bool) :
	visible = toggle_value
