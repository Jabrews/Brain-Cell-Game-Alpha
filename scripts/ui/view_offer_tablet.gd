extends Control

func _ready() -> void:
	GLPrisonerProfilerComponentsBus.connect('toggle_show_tablet_label', _handle_toggle_show_tablet_label)

func _handle_toggle_show_tablet_label(toggle_value : bool) :
	visible = toggle_value
